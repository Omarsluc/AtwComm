enum PodcastTypes {
  mobile,
  ai,
  security,
  others,
}

String podcastTypeToDbString(PodcastTypes type) {
  switch (type) {
    case PodcastTypes.mobile:
      return 'mobile';
    case PodcastTypes.ai:
      return 'AI';
    case PodcastTypes.security:
      return 'security';
    case PodcastTypes.others:
      return 'others';
  }
}
