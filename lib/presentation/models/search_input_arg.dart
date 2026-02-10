enum SearchSource {
  pins,
  boards,
  profile,
  unknown,
}

class SearchInputArgs {
  final SearchSource source;

  const SearchInputArgs({this.source = SearchSource.unknown});
}
