import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:junetech/core/widgets/custom_snack_bar.dart';
import 'package:junetech/features/scan/presentation/bloc/scan_cubit.dart';
import 'package:junetech/features/scan/presentation/pages/home_screen.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  MobileScannerController controller = MobileScannerController();
  String? scannedRegistrationNumber;
  bool isScanning = false;
  String scanMode = 'ENTREE';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    final barcode = capture.barcodes.first;
    if (barcode.rawValue != null && !isScanning) {
      final rawValue = barcode.rawValue!;
      print('QR code scanné : $rawValue');
      final parts =
          rawValue.trim().split('/').where((part) => part.isNotEmpty).toList();
      if (parts.isEmpty) {
        CustomSnackBar.show(
          context,
          content: 'QR code invalide : aucun numéro d\'enregistrement trouvé',
          status: ContentType.failure,
          duration: const Duration(seconds: 6),
        );
        return;
      }
      final registrationNumber = parts.last;
      if (!RegExp(r'^[A-Z]{3}[A-Z]{3}$').hasMatch(registrationNumber)) {
        CustomSnackBar.show(
          context,
          content:
              'Numéro d\'enregistrement invalide : doit être 6 lettres majuscules (ex. ABCDEF)',
          status: ContentType.failure,
          duration: const Duration(seconds: 6),
        );
        return;
      }
      setState(() {
        isScanning = true;
        scannedRegistrationNumber = registrationNumber;
      });
      context.read<ScanCubit>().recordScan(
            registrationNumber: scannedRegistrationNumber!,
            typeScan: scanMode,
            jourEvenement: 1,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScanCubit, ScanState>(
      listener: (context, state) {
        if (state is ScanError) {
          CustomSnackBar.show(
            context,
            content: state.message,
            status: ContentType.failure,
            duration: const Duration(seconds: 6),
          );
          setState(() {
            isScanning = false;
            scannedRegistrationNumber = null;
          });
          controller.start();
        } else if (state is ScanLoaded && scannedRegistrationNumber != null) {
          CustomSnackBar.show(
            context,
            content: 'Scan réussi : $scannedRegistrationNumber',
            status: ContentType.success,
            duration: const Duration(seconds: 3),
          );
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<ScanCubit>(),
                    child: const HomeScreen(),
                  ),
                ),
                (route) => false,
              );
            }
          });
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A23),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Scanner QR Code',
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
        body: Column(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
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
                child: Stack(
                  children: [
                    MobileScanner(
                      controller: controller,
                      onDetect: _onDetect,
                    ),
                    if (isScanning)
                      const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFF6AD55),
                        ),
                      )
                          .animate()
                          .scale(duration: const Duration(milliseconds: 500)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChoiceChip(
                    label: const Text('Entrée',
                        style: TextStyle(color: Colors.white)),
                    selected: scanMode == 'ENTREE',
                    selectedColor: const Color(0xFFF6AD55),
                    backgroundColor: const Color(0xFF2A2A2A),
                    onSelected: (selected) {
                      if (selected) setState(() => scanMode = 'ENTREE');
                    },
                  ),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    label: const Text('Sortie',
                        style: TextStyle(color: Colors.white)),
                    selected: scanMode == 'SORTIE',
                    selectedColor: const Color(0xFFF6AD55),
                    backgroundColor: const Color(0xFF2A2A2A),
                    onSelected: (selected) {
                      if (selected) setState(() => scanMode = 'SORTIE');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
