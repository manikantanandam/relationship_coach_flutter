import 'package:flutter/material.dart';
import 'package:relationship_coach_flutter/enum/feature_flag_key.dart';
import 'package:relationship_coach_flutter/services/local_feature_flag_manager.dart';

class LocalFeatureFlagScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final manager = LocalFeatureFlagManager();

    return Scaffold(
      appBar: AppBar(title: const Text('Advanced Feature Flags')),
      body: ListenableBuilder(
        listenable: manager,
        builder: (context, _) {
          return ListView(
            children: FeatureKey.values.map((feature) {
              final currentValue = manager.getValue(feature);

              if (currentValue is bool) {
                return SwitchListTile(
                  title: Text(feature.name),
                  value: currentValue,
                  onChanged: (val) => manager.setValue(feature, val),
                );
              }

              if (currentValue is Enum) {
                return ListTile(
                  title: Text(feature.name),
                  trailing: DropdownButton<Enum>(
                    value: currentValue,
                    // Access the options directly from the FeatureKey
                    items: feature.options?.map<DropdownMenuItem<Enum>>((
                      Enum e,
                    ) {
                      return DropdownMenuItem<Enum>(
                        value: e,
                        child: Text(e.name),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) manager.setValue(feature, val);
                    },
                  ),
                );
              }
              return const SizedBox.shrink();
            }).toList(),
          );
        },
      ),
    );
  }
}
