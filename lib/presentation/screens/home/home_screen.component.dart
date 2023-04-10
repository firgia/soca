/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Mon Mar 20 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'home_screen.dart';

class _UserProfile extends StatelessWidget {
  const _UserProfile();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoaded) {
          return ProfileCard(
            key: const Key("home_screen_profile_card"),
            user: state.data,
          );
        } else {
          return const ProfileCard.loading(
            key: Key("home_screen_profile_card_loading"),
          );
        }
      },
    );
  }
}

class _UserAction extends StatelessWidget {
  const _UserAction();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoaded) {
          UserType? type = state.data.type;
          if (type == UserType.volunteer) {
            return const VolunteerInfoCard();
          } else if (type == UserType.blind) {
            return Padding(
              padding: const EdgeInsets.all(kDefaultSpacing),
              child: CallVolunteerButton(
                onPressed: () {
                  sl<AppNavigator>().goToCreateCall(context, user: state.data);
                },
              ),
            );
          } else {
            return const SizedBox();
          }
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

class _LoadingWrapper extends StatelessWidget {
  const _LoadingWrapper({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        BlocBuilder<RouteCubit, RouteState>(
          builder: (context, state) {
            bool isLoading = state is RouteLoading;

            if (isLoading) {
              return const LoadingPanel();
            } else {
              return const SizedBox();
            }
          },
        ),
      ],
    );
  }
}
