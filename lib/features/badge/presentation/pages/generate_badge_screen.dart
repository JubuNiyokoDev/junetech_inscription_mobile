import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:junetech/core/widgets/custom_snack_bar.dart';
import 'package:junetech/features/badge/presentation/bloc/badge_cubit.dart';
import 'package:junetech/service_locator.dart';
import 'dart:typed_data';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class GenerateBadgeScreen extends StatefulWidget {
  const GenerateBadgeScreen({super.key});

  @override
  State<GenerateBadgeScreen> createState() => _GenerateBadgeScreenState();
}

class _GenerateBadgeScreenState extends State<GenerateBadgeScreen> {
  final TextEditingController _registrationNumberController =
      TextEditingController();

  Future<void> _printBadge(Uint8List badgeImage) async {
    try {
      final pdf = pw.Document();
      final image = pw.MemoryImage(badgeImage);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(image, fit: pw.BoxFit.contain),
            );
          },
        ),
      );

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {
      CustomSnackBar.show(
        context,
        content: '${e.toString()}',
        status: ContentType.failure,
        duration: const Duration(seconds: 6),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BadgeCubit>(),
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A23),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Generate Badge',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              shadows: [Shadow(color: Colors.black45, blurRadius: 5)],
            ),
          ),
          leading: IconButton(
            icon: const Icon(HugeIcons.strokeRoundedArrowLeft01,
                color: Color(0xFFF6AD55)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocConsumer<BadgeCubit, BadgeState>(
          listener: (context, state) {
            if (state is BadgeError) {
              CustomSnackBar.show(
                context,
                content: state.message,
                status: ContentType.failure,
                duration: const Duration(seconds: 6),
              );
            } else if (state is BadgeSuccess) {
              CustomSnackBar.show(
                context,
                content: 'Badge généré avec succès',
                status: ContentType.success,
                duration: const Duration(seconds: 3),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is BadgeLoading;
            Uint8List? badgeImage =
                state is BadgeSuccess ? state.badgeImage : null;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF6B46C1), Color(0xFFD53F8C)],
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(107, 70, 193, 0.4),
                            blurRadius: 15,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          TextField(
                            controller: _registrationNumberController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Numéro d\'inscription',
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Color(0xFFF6AD55)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () => context
                                    .read<BadgeCubit>()
                                    .generateBadge(
                                        _registrationNumberController.text),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF6AD55),
                              foregroundColor: const Color(0xFF0A0A23),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              elevation: 5,
                            ),
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    color: Color(0xFF0A0A23))
                                : const Text(
                                    'Générer le badge',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (badgeImage != null) ...[
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(107, 70, 193, 0.4),
                              blurRadius: 15,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.memory(
                            badgeImage,
                            width: 300,
                            height: 400,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _printBadge(badgeImage),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF6AD55),
                          foregroundColor: const Color(0xFF0A0A23),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          elevation: 5,
                        ),
                        child: const Text(
                          'Imprimer le badge',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
