import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gp5/extensions/build_context_extensions.dart';
import 'package:flutter_gp5/locale/l10n/app_locale.dart';
import '../../../repos/user/user_repository.dart';
import '../../../widgets/bottom_nav_bar.dart' as custom;
import '../../../widgets/custom_circular_progress_indicator.dart';
import '../bloc/models/detailed_doctor_model.dart';
import 'bloc/doctor_bloc.dart';
import 'bloc/doctor_event.dart';
import 'bloc/doctor_state.dart';

class DoctorDetailScreen extends StatelessWidget {
  final String doctorId;

  const DoctorDetailScreen({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(context.setHeight(7)),
        child: Padding(
          padding: EdgeInsets.only(top: context.setHeight(3)),
          child: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.navigate_before,
                color: Colors.black,
                size: 32,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              AppLocale.of(context)!.titleHome,
              style: TextStyle(
                color: const Color(0xFF1D1B20),
                fontSize: context.setWidth(5),
                fontWeight: FontWeight.w400,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => DoctorBloc(userRepository: RepositoryProvider.of<UserRepository>(context))
          ..add(GetDoctorDetails(doctorId)),
        child: Stack(
          children: [
            backgroundDecoration(),
            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(context.setWidth(5)),
                  child: BlocBuilder<DoctorBloc, DoctorStates>(
                    builder: (context, state) {
                      if (state is DoctorLoadingState) {
                        return buildLoadingWidget(context);
                      } else if (state is DoctorLoadedState) {
                        final doctorDetail = state.doctorDetail;
                        return buildDoctorDetail(context, doctorDetail);
                      } else if (state is DoctorErrorState) {
                        return Center(child: Text(state.error));
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const custom.BottomNavigationBar(currentIndex: 2),
    );
  }

  Widget backgroundDecoration() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/home.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildLoadingWidget(BuildContext context) {
    return SizedBox(
      height: context.setHeight(80),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocale.of(context)!.loading,
              style: TextStyle(
                fontSize: context.setWidth(5),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: context.setHeight(3)),
            const CustomCircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  Widget buildDoctorDetail(BuildContext context, DoctorDetail doctorDetail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: context.setWidth(15),
              backgroundImage: doctorDetail.imageUrl.isNotEmpty
                  ? NetworkImage(doctorDetail.imageUrl)
                  : const NetworkImage('https://static-00.iconduck.com/assets.00/profile-default-icon-2048x2045-u3j7s5nj.png'),
            ),
            SizedBox(width: context.setWidth(5)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctorDetail.name,
                    style: TextStyle(
                      fontSize: context.setWidth(6),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    doctorDetail.speciality,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: context.setWidth(4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: context.setHeight(2)),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton.icon(
                onPressed: null,
                icon: const Icon(Icons.add, color: Color(0xFF6750A4)),
                label: Text(
                  AppLocale.of(context)!.messages,
                  style: TextStyle(
                    color: const Color(0xFF6750A4),
                    fontSize: context.setWidth(4),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: context.setHeight(1.5),
                    horizontal: context.setWidth(6),
                  ),
                  side: const BorderSide(color: Color(0xFF6750A4), width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(context.setWidth(8)),
                  ),
                ),
              ),
              SizedBox(width: context.setWidth(4)),
              ElevatedButton.icon(
                onPressed: null,
                icon: const Icon(Icons.add, color: Colors.white),
                label: Text(
                  AppLocale.of(context)!.connect,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: context.setWidth(4),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: context.setHeight(1.5),
                    horizontal: context.setWidth(6),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(context.setWidth(8)),
                  ),
                  backgroundColor: const Color(0xFF6750A4),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: context.setHeight(2)),
        const Divider(),
        SizedBox(height: context.setHeight(2)),
        Text(
          doctorDetail.description.isNotEmpty
              ? doctorDetail.description
              : AppLocale.of(context)!.noDescription,
          style: TextStyle(
            fontSize: context.setWidth(4),
            color: Colors.grey[800],
            height: 1.5,
          ),
        ),
        SizedBox(height: context.setHeight(2)),
        const Divider(),
        Text(
          'Explore trials by Dr. ${doctorDetail.name}',
          style: TextStyle(
            fontSize: context.setWidth(5),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: context.setHeight(1)),
        _buildTrialList(context),
      ],
    );
  }

  Widget _buildTrialList(BuildContext context) {
    List<Map<String, String>> trials = [
      {
        'title': 'Trial Category 1',
        'description': 'Short trial description. #placeholder text',
      },
      {
        'title': 'Trial Category 2',
        'description': 'Another trial description. #placeholder text',
      },
      {
        'title': 'Trial Category 3',
        'description': 'Another trial description. #placeholder text',
      },
    ];

    return Column(
      children: trials.map((trial) {
        return StatefulBuilder(
          builder: (context, setState) {
            bool isExpanded = false;
            return Column(
              children: [
                ExpansionTile(
                  key: ValueKey(trial['title']),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        trial['title']!,
                        style: TextStyle(
                          fontSize: context.setWidth(4.5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.menu, color: Colors.black),
                          SizedBox(width: context.setWidth(2)),
                          const Icon(Icons.expand_more, color: Colors.black),
                        ],
                      ),
                    ],
                  ),
                  onExpansionChanged: (expanded) {
                    setState(() {
                      isExpanded = expanded;
                    });
                  },
                  trailing: SizedBox.shrink(), // Remove default arrow
                  children: [
                    ListTile(
                      title: Text(
                        trial['description']!,
                        style: TextStyle(fontSize: context.setWidth(4)),
                      ),
                    ),
                  ],
                ),
                if (!isExpanded) const Divider(),
              ],
            );
          },
        );
      }).toList(),
    );
  }
}
