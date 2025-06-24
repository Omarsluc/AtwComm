abstract class ArticleState {}

class ArticleInitialState extends ArticleState {}

class TTSInitial extends ArticleState {}

class TTSLoading extends ArticleState {}

class TTSVoicesLoaded extends ArticleState {}

class TTSSpeaking extends ArticleState {}

class TTSPlaying extends ArticleState {}

class TTSPaused extends ArticleState {}

class TTSStopped extends ArticleState {}

class TTSError extends ArticleState {}