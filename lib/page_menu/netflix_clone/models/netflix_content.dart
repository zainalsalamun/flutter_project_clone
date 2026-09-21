class NetflixContent {
  final String id;
  final String title;
  final String posterUrl;
  final String backdropUrl;
  final String logoUrl;
  final String synopsis;
  final String matchScore;
  final String maturityRating;
  final String durationOrSeasons;
  final bool isOriginal;
  final bool isTop10;
  final int? top10Rank;
  final List<String> genres;
  final double? watchProgress; // 0.0 to 1.0 for continue watching
  final List<Episode>? episodes;
  final List<String> cast;

  const NetflixContent({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.backdropUrl,
    this.logoUrl = '',
    required this.synopsis,
    this.matchScore = '98% Match',
    this.maturityRating = '18+',
    this.durationOrSeasons = '2 Seasons',
    this.isOriginal = true,
    this.isTop10 = false,
    this.top10Rank,
    this.genres = const ['Sci-Fi', 'Suspense', 'Drama'],
    this.watchProgress,
    this.episodes,
    this.cast = const ['Millie Bobby Brown', 'Finn Wolfhard', 'Winona Ryder'],
  });

  static List<NetflixContent> get featuredContent => [
        const NetflixContent(
          id: 'feat_1',
          title: 'STRANGER THINGS',
          posterUrl: 'https://images.unsplash.com/photo-1618336753974-aae8e04506aa?w=600&auto=format&fit=crop&q=80',
          backdropUrl: 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=1200&auto=format&fit=crop&q=80',
          synopsis:
              'When a young boy vanishes, a small town uncovers a mystery involving secret experiments, terrifying supernatural forces and one strange little girl.',
          matchScore: '99% Match',
          maturityRating: '16+',
          durationOrSeasons: '4 Seasons',
          isOriginal: true,
          isTop10: true,
          top10Rank: 1,
          genres: ['Nostalgic', 'Sci-Fi TV', 'Teen Scream', 'Dark'],
          cast: ['Winona Ryder', 'David Harbour', 'Millie Bobby Brown', 'Finn Wolfhard'],
          episodes: [
            Episode(
              number: 1,
              title: 'Chapter One: The Vanishing of Will Byers',
              duration: '48m',
              synopsis:
                  'On his way home from a friend’s house, young Will sees something terrifying. Nearby, a sinister secret lurks in the depths of a government lab.',
              thumbnailUrl:
                  'https://images.unsplash.com/photo-1509198397868-475647b2a1e5?w=400&auto=format&fit=crop&q=80',
            ),
            Episode(
              number: 2,
              title: 'Chapter Two: The Weirdo on Maple Street',
              duration: '55m',
              synopsis:
                  'Lucas, Mike and Dustin try to talk to the girl they found in the woods. Hopper questions an anxious Joyce about an unsettling phone call.',
              thumbnailUrl:
                  'https://images.unsplash.com/photo-1579783902614-a3fb3927b675?w=400&auto=format&fit=crop&q=80',
            ),
            Episode(
              number: 3,
              title: 'Chapter Three: Holly, Jolly',
              duration: '51m',
              synopsis:
                  'An increasingly frantic Joyce believes Will is communicating with her through Christmas lights. Barb accompanies Nancy to a party.',
              thumbnailUrl:
                  'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=400&auto=format&fit=crop&q=80',
            ),
          ],
        ),
      ];

  static List<NetflixContent> get continueWatching => [
        const NetflixContent(
          id: 'cw_1',
          title: 'Cyberpunk: Edgerunners',
          posterUrl: 'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=600&auto=format&fit=crop&q=80',
          backdropUrl: 'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=1200&auto=format&fit=crop&q=80',
          synopsis:
              'A street kid trying to survive in a technology and body modification-obsessed city of the future. Having everything to lose, he chooses to become an edgerunner.',
          matchScore: '97% Match',
          maturityRating: '18+',
          durationOrSeasons: '1 Season',
          isOriginal: true,
          watchProgress: 0.65,
          genres: ['Anime', 'Cyberpunk', 'Action', 'Sci-Fi'],
        ),
        const NetflixContent(
          id: 'cw_2',
          title: 'The Witcher',
          posterUrl: 'https://images.unsplash.com/photo-1514533450685-4493e01d1fdc?w=600&auto=format&fit=crop&q=80',
          backdropUrl: 'https://images.unsplash.com/photo-1514533450685-4493e01d1fdc?w=1200&auto=format&fit=crop&q=80',
          synopsis:
              'Geralt of Rivia, a mutated monster-hunter for hire, journeys toward his destiny in a turbulent world where people often prove more wicked than beasts.',
          matchScore: '95% Match',
          maturityRating: '18+',
          durationOrSeasons: '3 Seasons',
          isOriginal: true,
          watchProgress: 0.35,
          genres: ['Fantasy', 'Action', 'Dark', 'Drama'],
        ),
        const NetflixContent(
          id: 'cw_3',
          title: 'Arcane',
          posterUrl: 'https://images.unsplash.com/photo-1563089145-599997674d42?w=600&auto=format&fit=crop&q=80',
          backdropUrl: 'https://images.unsplash.com/photo-1563089145-599997674d42?w=1200&auto=format&fit=crop&q=80',
          synopsis:
              'Set in the utopian region of Piltover and the oppressed underground of Zaun, the story follows the origins of two iconic League champions-and the power that will tear them apart.',
          matchScore: '99% Match',
          maturityRating: '16+',
          durationOrSeasons: '2 Seasons',
          isOriginal: true,
          watchProgress: 0.85,
          genres: ['Animation', 'Steampunk', 'Action', 'Drama'],
        ),
        const NetflixContent(
          id: 'cw_4',
          title: 'Dark',
          posterUrl: 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=600&auto=format&fit=crop&q=80',
          backdropUrl: 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=1200&auto=format&fit=crop&q=80',
          synopsis:
              'A family saga with a supernatural twist, set in a German town where the disappearance of two young children exposes the relationships among four families.',
          matchScore: '96% Match',
          maturityRating: '18+',
          durationOrSeasons: '3 Seasons',
          isOriginal: true,
          watchProgress: 0.2,
          genres: ['Mind-Bending', 'Mystery', 'Sci-Fi', 'German'],
        ),
      ];

  static List<NetflixContent> get top10Today => [
        const NetflixContent(
          id: 'top_1',
          title: 'Squid Game',
          posterUrl: 'https://images.unsplash.com/photo-1634157703702-3c124b455499?w=600&auto=format&fit=crop&q=80',
          backdropUrl: 'https://images.unsplash.com/photo-1634157703702-3c124b455499?w=1200&auto=format&fit=crop&q=80',
          synopsis:
              'Hundreds of cash-strapped players accept a strange invitation to compete in children\'s games. Inside, a tempting prize awaits with deadly high stakes.',
          matchScore: '98% Match',
          maturityRating: '18+',
          durationOrSeasons: '2 Seasons',
          isOriginal: true,
          isTop10: true,
          top10Rank: 1,
          genres: ['Thriller', 'Suspense', 'Korean', 'Dystopian'],
        ),
        const NetflixContent(
          id: 'top_2',
          title: 'Wednesday',
          posterUrl: 'https://images.unsplash.com/photo-1509198397868-475647b2a1e5?w=600&auto=format&fit=crop&q=80',
          backdropUrl: 'https://images.unsplash.com/photo-1509198397868-475647b2a1e5?w=1200&auto=format&fit=crop&q=80',
          synopsis:
              'Smart, sarcastic and a little dead inside, Wednesday Addams investigates a murder spree while making new friends — and foes — at Nevermore Academy.',
          matchScore: '96% Match',
          maturityRating: '13+',
          durationOrSeasons: '1 Season',
          isOriginal: true,
          isTop10: true,
          top10Rank: 2,
          genres: ['Mystery', 'Supernatural', 'Comedy', 'Dark'],
        ),
        const NetflixContent(
          id: 'top_3',
          title: 'One Piece (Live Action)',
          posterUrl: 'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=600&auto=format&fit=crop&q=80',
          backdropUrl: 'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=1200&auto=format&fit=crop&q=80',
          synopsis:
              'With his straw hat and ragtag crew, young pirate Monkey D. Luffy goes on an epic voyage for treasure in this live-action adaptation of the popular manga.',
          matchScore: '95% Match',
          maturityRating: '13+',
          durationOrSeasons: '1 Season',
          isOriginal: true,
          isTop10: true,
          top10Rank: 3,
          genres: ['Adventure', 'Action', 'Fantasy', 'Exciting'],
        ),
        const NetflixContent(
          id: 'top_4',
          title: 'Black Mirror',
          posterUrl: 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&auto=format&fit=crop&q=80',
          backdropUrl: 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=1200&auto=format&fit=crop&q=80',
          synopsis:
              'This sci-fi anthology series explores a twisted, high-tech near-future where humanity\'s greatest innovations and darkest instincts collide.',
          matchScore: '94% Match',
          maturityRating: '18+',
          durationOrSeasons: '6 Seasons',
          isOriginal: true,
          isTop10: true,
          top10Rank: 4,
          genres: ['Dystopian', 'Sci-Fi', 'Anthology', 'Mind-Bending'],
        ),
        const NetflixContent(
          id: 'top_5',
          title: 'Money Heist (La Casa de Papel)',
          posterUrl: 'https://images.unsplash.com/photo-1579783900882-c0d3dad7b119?w=600&auto=format&fit=crop&q=80',
          backdropUrl: 'https://images.unsplash.com/photo-1579783900882-c0d3dad7b119?w=1200&auto=format&fit=crop&q=80',
          synopsis:
              'Eight thieves take hostages and lock themselves in the Royal Mint of Spain as a criminal mastermind manipulates the police to carry out his plan.',
          matchScore: '98% Match',
          maturityRating: '18+',
          durationOrSeasons: '5 Parts',
          isOriginal: true,
          isTop10: true,
          top10Rank: 5,
          genres: ['Suspense', 'Crime', 'Spanish', 'Exciting'],
        ),
      ];

  static List<NetflixContent> get trendingNow => [
        const NetflixContent(
          id: 'tr_1',
          title: 'Interstellar',
          posterUrl: 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=600&auto=format&fit=crop&q=80',
          backdropUrl: 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=1200&auto=format&fit=crop&q=80',
          synopsis:
              'A team of explorers travel through a wormhole in space in an attempt to ensure humanity\'s survival as Earth faces catastrophic famine.',
          matchScore: '99% Match',
          maturityRating: '13+',
          durationOrSeasons: '2h 49m',
          isOriginal: false,
          genres: ['Sci-Fi', 'Space', 'Emotional', 'Epic'],
        ),
        const NetflixContent(
          id: 'tr_2',
          title: 'Inception',
          posterUrl: 'https://images.unsplash.com/photo-1509198397868-475647b2a1e5?w=600&auto=format&fit=crop&q=80',
          backdropUrl: 'https://images.unsplash.com/photo-1509198397868-475647b2a1e5?w=1200&auto=format&fit=crop&q=80',
          synopsis:
              'A thief who steals corporate secrets through dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O.',
          matchScore: '97% Match',
          maturityRating: '13+',
          durationOrSeasons: '2h 28m',
          isOriginal: false,
          genres: ['Mind-Bending', 'Sci-Fi', 'Action', 'Heist'],
        ),
        const NetflixContent(
          id: 'tr_3',
          title: 'Queen\'s Gambit',
          posterUrl: 'https://images.unsplash.com/photo-1529699211952-734e80c4d42b?w=600&auto=format&fit=crop&q=80',
          backdropUrl: 'https://images.unsplash.com/photo-1529699211952-734e80c4d42b?w=1200&auto=format&fit=crop&q=80',
          synopsis:
              'Orphaned at the tender age of nine, prodigious introvert Beth Harmon discovers and masters the game of chess in 1960s USA. But child stardom comes at a price.',
          matchScore: '99% Match',
          maturityRating: '16+',
          durationOrSeasons: 'Limited Series',
          isOriginal: true,
          genres: ['Drama', 'Intimate', 'Emotional', 'Period Piece'],
        ),
        const NetflixContent(
          id: 'tr_4',
          title: 'Peaky Blinders',
          posterUrl: 'https://images.unsplash.com/photo-1485846234645-a62644f84728?w=600&auto=format&fit=crop&q=80',
          backdropUrl: 'https://images.unsplash.com/photo-1485846234645-a62644f84728?w=1200&auto=format&fit=crop&q=80',
          synopsis:
              'A notorious gang in 1919 Birmingham, England, is led by the fierce Tommy Shelby, a crime boss set on moving up in the world no matter the cost.',
          matchScore: '98% Match',
          maturityRating: '18+',
          durationOrSeasons: '6 Seasons',
          isOriginal: false,
          genres: ['Crime TV', 'Period Piece', 'Gritty', 'British'],
        ),
      ];

  static List<NetflixContent> get animeCollection => [
        const NetflixContent(
          id: 'an_1',
          title: 'Demon Slayer: Kimetsu no Yaiba',
          posterUrl: 'https://images.unsplash.com/photo-1578632767115-351597cf2477?w=600&auto=format&fit=crop&q=80',
          backdropUrl: 'https://images.unsplash.com/photo-1578632767115-351597cf2477?w=1200&auto=format&fit=crop&q=80',
          synopsis:
              'After a demon attack leaves his family slain and his sister cursed, Tanjiro Kamado embarks upon a perilous journey to find a cure and avenge his family.',
          matchScore: '99% Match',
          maturityRating: '16+',
          durationOrSeasons: '4 Seasons',
          isOriginal: false,
          genres: ['Anime', 'Action', 'Supernatural', 'Emotional'],
        ),
        const NetflixContent(
          id: 'an_2',
          title: 'Jujutsu Kaisen',
          posterUrl: 'https://images.unsplash.com/photo-1563089145-599997674d42?w=600&auto=format&fit=crop&q=80',
          backdropUrl: 'https://images.unsplash.com/photo-1563089145-599997674d42?w=1200&auto=format&fit=crop&q=80',
          synopsis:
              'A boy swallows a cursed talisman - the finger of a demon - and becomes cursed himself. He enters a shaman\'s school to be able to locate the demon\'s other body parts.',
          matchScore: '98% Match',
          maturityRating: '16+',
          durationOrSeasons: '2 Seasons',
          isOriginal: false,
          genres: ['Anime Series', 'Dark Fantasy', 'Supernatural', 'Action'],
        ),
        const NetflixContent(
          id: 'an_3',
          title: 'Attack on Titan',
          posterUrl: 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=600&auto=format&fit=crop&q=80',
          backdropUrl: 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=1200&auto=format&fit=crop&q=80',
          synopsis:
              'After his hometown is destroyed and his mother is killed, young Eren Jaeger vows to cleanse the earth of the giant humanoid Titans that have brought humanity to the brink of extinction.',
          matchScore: '99% Match',
          maturityRating: '18+',
          durationOrSeasons: '4 Seasons',
          isOriginal: false,
          genres: ['Anime Series', 'Epic', 'Dystopian', 'Dark Fantasy'],
        ),
      ];
}

class Episode {
  final int number;
  final String title;
  final String duration;
  final String synopsis;
  final String thumbnailUrl;

  const Episode({
    required this.number,
    required this.title,
    required this.duration,
    required this.synopsis,
    required this.thumbnailUrl,
  });
}
