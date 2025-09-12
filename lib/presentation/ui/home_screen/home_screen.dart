import 'package:flutter/material.dart';
import 'package:noviindus_task/core/color_config.dart';
import 'package:noviindus_task/core/size_config.dart';
import 'package:noviindus_task/presentation/ui/home_screen/widgets/patient_card.dart';
import 'package:noviindus_task/presentation/ui/home_screen/widgets/sort_widget.dart';
import 'package:noviindus_task/presentation/ui/home_screen/widgets/top_search.dart';
import 'package:noviindus_task/presentation/ui/register_patient_screen/register_patient_screen.dart';
import 'package:provider/provider.dart';
import 'package:noviindus_task/presentation/providers/patient_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PatientProvider>().loadPatients();
    });
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<PatientProvider>();

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: prov.refresh,
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight / 12),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.arrow_back, color: ColorConfig.iconColor),
                    Icon(
                      Icons.notifications_none_outlined,
                      color: ColorConfig.iconColor,
                    ),
                  ],
                ),
              ),
              SearchBarWithButton(),
              SortByWidget(),
              Container(
                height: 1,
                width: SizeConfig.screenWidth,
                color: ColorConfig.borderGrey,
              ),
              SizedBox(height: 5),
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (prov.status == PatientStatus.initial ||
                        prov.status == PatientStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (prov.status == PatientStatus.error) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Error: ${prov.errorMessage ?? 'Unknown error'}',
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () => prov.loadPatients(force: true),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    } else if (prov.status == PatientStatus.empty) {
                      return ListView(
                        children: const [
                          SizedBox(height: 120),
                          Center(
                            child: Text(
                              'No patients',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 84),
                      itemCount: prov.patients.length,
                      itemBuilder: (context, i) =>
                          PatientCard(index: i, patient: prov.patients[i]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        color: Colors.white,
        child: SizedBox(
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => RegisterPatientScreen(),
                ),
              );
            },
            child: Text(
              'Register Now',
              style: TextStyle(fontSize: 16, color: ColorConfig.textWhite),
            ),
          ),
        ),
      ),
    );
  }
}
