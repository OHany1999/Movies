abstract class HomeStates{}
class InitHomeState extends HomeStates{}


class SuccessGetPopularState extends HomeStates{}
class ErrorGetPopularState extends HomeStates{}


class SuccessGetNewReleasesState extends HomeStates{}
class ErrorGetNewReleasesState extends HomeStates{}


class SuccessGetRecommendedState extends HomeStates{}
class ErrorGetRecommendedState extends HomeStates{}

class SuccessGetFromStoreToHomeScreenState extends HomeStates{}


class AddedToFirebaseState extends HomeStates{}
class DeletedFromFirebaseState extends HomeStates{}