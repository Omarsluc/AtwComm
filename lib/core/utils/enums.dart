enum PodcastTypes {
  mobile,
  backend,
  design,
  ai,
  managing,
  front,
  security,
  others,
}

String podcastTypeToDbString(PodcastTypes type) {
  switch (type) {
    case PodcastTypes.mobile:
      return 'mobile';
    case PodcastTypes.backend:
      return 'backend';
    case PodcastTypes.design:
      return 'design';
    case PodcastTypes.ai:
      return 'AI';
    case PodcastTypes.managing:
      return 'managing';
    case PodcastTypes.front:
      return 'front';
    case PodcastTypes.security:
      return 'security';
    case PodcastTypes.others:
      return 'others';
  }
}
