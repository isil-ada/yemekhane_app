import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';

class RateMenuScreen extends StatefulWidget {
  final String? mealId;
  const RateMenuScreen({super.key, this.mealId});

  @override
  State<RateMenuScreen> createState() => _RateMenuScreenState();
}

class _RateMenuScreenState extends State<RateMenuScreen> {
  int _selectedStars = 0;
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (widget.mealId == null) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Hata: Yemek ID bulunamadı.")));
       return;
    }
    if (_selectedStars == 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lütfen bir puan seçin.")));
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // 1. Submit Rating
      await ApiService.post('/rate', {
        'meal_id': widget.mealId,
        'score': _selectedStars,
      });

      // 2. Submit Comment (if any)
      if (_commentController.text.trim().isNotEmpty) {
        await ApiService.post('/comments', {
          'meal_id': widget.mealId,
          'comment_text': _commentController.text.trim(),
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Değerlendirmeniz başarıyla gönderildi!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      print('Rate/Comment submit error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text("Bir hata oluştu: $e"), backgroundColor: Colors.red,),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Yemeği Değerlendir",
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0D326F),
        elevation: 0,
        leading: BackButton(color: const Color(0xFF0D326F)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                "Bugünkü menüyü nasıl buldunuz?",
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () {
                      setState(() {
                        _selectedStars = index + 1;
                      });
                    },
                    icon: Icon(
                      index < _selectedStars ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 40,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _commentController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Yorumunuzu yazın...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D326F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSubmitting 
                    ? const SizedBox(width:24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2,)) 
                    : Text(
                    "Gönder",
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
