part of 'user_bloc.dart';

enum UserStatus { initial, loading, success, failure }

class UserState extends AppState {
  final UserStatus status;
  final User? user;
  final List<UserInterest> interests;
  final List<Subject> subjects;
  final List<Vote> voteHistory;
  final List<AgeCategory> ageCategories;
  final List<SexCategory> sexCategories;
  final bool isLoadingVoteHistory;

  const UserState({
    required this.status,
    this.user,
    this.interests = const [],
    this.subjects = const [],
    this.voteHistory = const [],
    this.ageCategories = const [],
    this.sexCategories = const [],
    this.isLoadingVoteHistory = false,
    super.failure,
  });

  const UserState.initial()
      : status = UserStatus.initial,
        user = null,
        interests = const [],
        subjects = const [],
        voteHistory = const [],
        ageCategories = const [],
        sexCategories = const [],
        isLoadingVoteHistory = false,
        super(failure: null);

  UserState copyWith({
    UserStatus? status,
    User? user,
    List<UserInterest>? interests,
    List<Subject>? subjects,
    List<Vote>? voteHistory,
    List<AgeCategory>? ageCategories,
    List<SexCategory>? sexCategories,
    bool? isLoadingVoteHistory,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return UserState(
      status: status ?? this.status,
      user: user ?? this.user,
      interests: interests ?? this.interests,
      subjects: subjects ?? this.subjects,
      voteHistory: voteHistory ?? this.voteHistory,
      ageCategories: ageCategories ?? this.ageCategories,
      sexCategories: sexCategories ?? this.sexCategories,
      isLoadingVoteHistory: isLoadingVoteHistory ?? this.isLoadingVoteHistory,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }

  @override
  List<Object?> get props => [...super.props, status, user, interests, subjects, voteHistory, ageCategories, sexCategories, isLoadingVoteHistory];
}
