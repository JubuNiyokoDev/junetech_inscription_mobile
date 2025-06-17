import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:junetech/core/widgets/custom_snack_bar.dart';
import 'package:junetech/features/badge/presentation/pages/generate_badge_screen.dart';
import 'package:junetech/features/scan/presentation/bloc/scan_cubit.dart';

import 'package:junetech/features/scan/presentation/pages/scan_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _showScanDetails(BuildContext context, dynamic scan) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0A0A23),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Détails du Scan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(HugeIcons.strokeRoundedCancelCircle,
                      color: Color(0xFFF6AD55)),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _DetailRow(label: 'Visiteur', value: scan.registration),
            _DetailRow(label: 'Type', value: scan.typeScan),
            _DetailRow(label: 'Jour', value: scan.jourEvenement.toString()),
            _DetailRow(
                label: 'Date',
                value: scan.dateScan.toString().substring(0, 16)),
          ],
        ),
      ).animate().slideY(
            begin: 1.0,
            end: 0.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          ),
    );
  }

  void _confirmDeleteScan(BuildContext context, int scanId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0A0A23),
        title: const Text(
          'Confirmer la suppression',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Voulez-vous vraiment supprimer ce scan ?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler',
                style: TextStyle(color: Color(0xFFF6AD55))),
          ),
          TextButton(
            onPressed: () {
              context.read<ScanCubit>().deleteScan(scanId, 1);
              Navigator.pop(context);
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ).animate().scale(duration: const Duration(milliseconds: 300)),
    );
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
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A23),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'JuneTech 5th Edition',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              shadows: [Shadow(color: Colors.black45, blurRadius: 5)],
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(HugeIcons.strokeRoundedRefresh,
                  color: Color(0xFFF6AD55)),
              onPressed: () {
                context.read<ScanCubit>().fetchScanSummary(1);
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<ScanCubit>(),
                        child: const ScanScreen(),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF6AD55),
                  foregroundColor: const Color(0xFF0A0A23),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Scanner',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ).animate().scale(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOut,
                  ),
            ),
            BlocBuilder<ScanCubit, ScanState>(
              builder: (context, state) {
                int entrees = 0;
                int sorties = 0;
                if (state is ScanLoaded) {
                  entrees = state.summary.totalEntrees;
                  sorties = state.summary.totalSorties;
                }
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _CounterCard(label: 'Entrées', count: entrees),
                      _CounterCard(label: 'Sorties', count: sorties),
                    ],
                  ),
                );
              },
            ),
            Expanded(
              child: BlocBuilder<ScanCubit, ScanState>(
                builder: (context, state) {
                  if (state is ScanLoading) {
                    return const Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFFF6AD55)),
                    );
                  } else if (state is ScanLoaded) {
                    final scans = state.summary.scans;
                    return ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: scans.length,
                      itemBuilder: (context, index) {
                        final scan = scans[index];
                        return Card(
                          color: Colors.transparent,
                          elevation: 0,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: Container(
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
                            child: ListTile(
                              onTap: () => _showScanDetails(context, scan),
                              title: Text(
                                scan.registration,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                '${scan.typeScan} - ${scan.dateScan.toString().substring(0, 16)}',
                                style: const TextStyle(color: Colors.white70),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                    HugeIcons.strokeRoundedDelete02,
                                    color: Colors.red),
                                onPressed: () =>
                                    _confirmDeleteScan(context, scan.id),
                              ),
                            ),
                          ),
                        ).animate().fadeIn(
                              duration: const Duration(milliseconds: 500),
                              delay: Duration(milliseconds: index * 100),
                            );
                      },
                    );
                  } else if (state is ScanError) {
                    return Center(
                      child: Text(
                        'Erreur: ${state.message}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  return const Center(
                    child: Text('Aucun scan',
                        style: TextStyle(color: Colors.white)),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GenerateBadgeScreen()),
            );
          },
          backgroundColor: const Color(0xFFF6AD55),
          child: const Icon(HugeIcons.strokeRoundedIdentification,
              color: Colors.black),
        ),
      ),
    );
  }
}

class _CounterCard extends StatelessWidget {
  final String label;
  final int count;

  const _CounterCard({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(16.0),
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
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 5),
          Text(
            '$count',
            style: const TextStyle(
              color: Color(0xFFF6AD55),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ).animate().scale(duration: const Duration(milliseconds: 500));
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label :',
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(color: Color(0xFFF6AD55), fontSize: 16),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
