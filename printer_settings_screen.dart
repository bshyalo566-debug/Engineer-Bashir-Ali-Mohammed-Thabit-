import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/printer_bloc.dart';

class PrinterSettingsScreen extends StatefulWidget {
  const PrinterSettingsScreen({super.key});

  @override
  State<PrinterSettingsScreen> createState() => _PrinterSettingsScreenState();
}

class _PrinterSettingsScreenState extends State<PrinterSettingsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PrinterBloc>().add(const DiscoverPrintersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إعدادات الطابعة'),
        centerTitle: true,
      ),
      body: BlocBuilder<PrinterBloc, PrinterState>(
        builder: (context, state) {
          if (state is PrinterDiscovering) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('جاري البحث عن الطابعات...'),
                ],
              ),
            );
          }

          if (state is PrintersDiscovered) {
            if (state.printers.isEmpty) {
              return _buildEmptyState();
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.printers.length,
              itemBuilder: (context, index) {
                final printer = state.printers[index];
                return Card(
                  child: ListTile(
                    leading: Icon(
                      printer.type.name == 'usb' 
                          ? Icons.usb 
                          : Icons.wifi,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(printer.name),
                    subtitle: Text('ID: ${printer.id}'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        context.read<PrinterBloc>().add(
                          ConnectPrinterEvent(printer),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('تم الاتصال بـ ${printer.name}')),
                        );
                      },
                      child: const Text('اتصال'),
                    ),
                  ),
                );
              },
            );
          }

          if (state is PrinterConnected) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.print,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'متصل بـ: ${state.printer.name}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<PrinterBloc>().add(const TestPrinterEvent());
                    },
                    icon: const Icon(Icons.print),
                    label: const Text('اختبار الطباعة'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () {
                      context.read<PrinterBloc>().add(const DisconnectPrinterEvent());
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('قطع الاتصال'),
                  ),
                ],
              ),
            );
          }

          return _buildEmptyState();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<PrinterBloc>().add(const DiscoverPrintersEvent());
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.print_disabled,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد طابعات متصلة',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'تأكد من توصيل الطابعة عبر USB OTG',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.read<PrinterBloc>().add(const DiscoverPrintersEvent());
            },
            icon: const Icon(Icons.search),
            label: const Text('بحث مجدداً'),
          ),
        ],
      ),
    );
  }
}
