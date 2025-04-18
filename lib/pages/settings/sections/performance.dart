import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingsPerformanceSection extends HookConsumerWidget {
  const SettingsPerformanceSection({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final cpuUsage = useState<double?>(null);
    final ramUsage = useState<double?>(null);
    final timer = useRef<Timer?>(null);

    useEffect(() {
      timer.value = Timer.periodic(const Duration(seconds: 2), (_) async {
        // Windows-specific: use systeminfo or wmic (très basique)
        if (Platform.isWindows) {
          // RAM
          final ramResult = await Process.run('wmic', ['OS', 'get', 'FreePhysicalMemory,TotalVisibleMemorySize', '/Value']);
          final ramLines = ramResult.stdout.toString().split('\n');
          final freeMem = int.tryParse(ramLines.firstWhere((l) => l.startsWith('FreePhysicalMemory'), orElse: () => '0').split('=').last.trim()) ?? 0;
          final totalMem = int.tryParse(ramLines.firstWhere((l) => l.startsWith('TotalVisibleMemorySize'), orElse: () => '0').split('=').last.trim()) ?? 1;
          ramUsage.value = 100.0 * (1 - freeMem / totalMem);
          // CPU (affichage symbolique)
          final cpuResult = await Process.run('wmic', ['cpu', 'get', 'loadpercentage']);
          final cpuLines = cpuResult.stdout.toString().split('\n');
          final cpuVal = double.tryParse(cpuLines[1].trim()) ?? 0;
          cpuUsage.value = cpuVal;
        }
      });
      return () {
        timer.value?.cancel();
      };
    }, []);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Performance (Mode Éco)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Utilisation CPU : ' + (cpuUsage.value?.toStringAsFixed(1) ?? '--') + ' %'),
            Text('Utilisation RAM : ' + (ramUsage.value?.toStringAsFixed(1) ?? '--') + ' %'),
            const SizedBox(height: 8),
            const Text('Le mode éco réduit la consommation en limitant les animations et le framerate.'),
          ],
        ),
      ),
    );
  }
}
