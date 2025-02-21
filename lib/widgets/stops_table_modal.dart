import 'package:flutter/material.dart';
import '../models/bus_stop.dart';
import '../utils/constants.dart';

class StopsTableModal extends StatelessWidget {
  final List<BusStop> stops;
  final BusStop? currentStop;

  const StopsTableModal({
    super.key,
    required this.stops,
    this.currentStop,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey)),
                ),
                child: const Text(
                  'All Stops',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: stops.length,
                  itemBuilder: (context, index) {
                    final stop = stops[index];
                    final isCurrentStop = stop.seq == currentStop?.seq;

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isCurrentStop 
                            ? AppColors.primary 
                            : AppColors.background,
                        child: Text(
                          stop.seq.toString(),
                          style: TextStyle(
                            color: isCurrentStop 
                                ? Colors.white 
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      title: Text(
                        stop.name,
                        style: TextStyle(
                          fontWeight: isCurrentStop 
                              ? FontWeight.bold 
                              : FontWeight.normal,
                        ),
                      ),
                      subtitle: Text('${stop.km.toStringAsFixed(1)} km'),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
} 