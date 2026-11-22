import 'dart:io';
import 'dart:typed_data';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import '../generated/protocol.dart';

const _imageQuery = '?auto=format&fit=crop&w=800&q=70';

const _fallbackImage =
    'https://images.unsplash.com/photo-1556740758-90de374c12ad$_imageQuery';

/// Curated, category-relevant demo photos. If one is unavailable the seeder
/// falls back to a known-good image and finally to a transparent placeholder.
const _productImages = <String, String>{
  'Traditional Phulkari Silk Dupatta':
      'https://images.unsplash.com/photo-1605000797499-95a51c5269ae$_imageQuery',
  'Handwoven Cotton Khadi Kurta':
      'https://images.unsplash.com/photo-1598033129183-c4f50c736f10$_imageQuery',
  'Powerloom Jacquard Cotton Bedsheet':
      'https://images.unsplash.com/photo-1584100936595-c0654b55a2e2$_imageQuery',
  'Terracotta Water Pitcher (Matka)':
      'https://images.unsplash.com/photo-1610701596007-11502861dcfa$_imageQuery',
  'Hand-painted Ceramic Teacup Set (6pcs)':
      'https://images.unsplash.com/photo-1514228742587-6b1558fcca3d$_imageQuery',
  'Traditional Clay Diya Set (Pack of 12)':
      'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da$_imageQuery',
  'Pure Pashmina Woolen Shawl':
      'https://images.unsplash.com/photo-1520903920243-00d872a2d1c9$_imageQuery',
  'Kashmiri Sozni Embroidered Stole':
      'https://images.unsplash.com/photo-1601924994987-69e26d50dc26$_imageQuery',
  'Aari Work Velvet Cushion Covers':
      'https://images.unsplash.com/photo-1584100936595-c0654b55a2e2$_imageQuery',
  'Organic Multi-Flora Raw Honey':
      'https://images.unsplash.com/photo-1587049352846-4a222e784d38$_imageQuery',
  'Pure Desi Sugarcane Jaggery (Gur)':
      'https://images.unsplash.com/photo-1542838132-92c53300491e$_imageQuery',
  'Cold-Pressed Yellow Mustard Oil':
      'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5$_imageQuery',
  'Sun-dried Punjabi Mango Pickle':
      'https://images.unsplash.com/photo-1596040033229-a9821ebd058d$_imageQuery',
  'Channapatna Wooden Toy Train':
      'https://images.unsplash.com/photo-1596461404969-9ae70f2830c1$_imageQuery',
  'Carved Sheesham Wood Spice Box':
      'https://images.unsplash.com/photo-1596040033229-a9821ebd058d$_imageQuery',
  'Teakwood Cutlery & Serving Spoons':
      'https://images.unsplash.com/photo-1610701596007-11502861dcfa$_imageQuery',
  'Hand-hammered Brass Cooking Kadhai':
      'https://images.unsplash.com/photo-1556910103-1c02745aae4d$_imageQuery',
  'Dhokra Lost-Wax Bell Metal Elephant':
      'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da$_imageQuery',
  'Pure Copper Water Bottle & Cups':
      'https://images.unsplash.com/photo-1602143407151-7111542de6e8$_imageQuery',
  'Bronze Heritage Pooja Thali Set':
      'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da$_imageQuery',
};

/// Idempotent demo seed. Runs on startup and skips once the catalog is full.
Future<void> seedDemoData(Serverpod pod) async {
  final session = await pod.createSession();
  try {
    final existingProductsCount = await Product.db.count(session);
    if (existingProductsCount >= 10) {
      session.log(
        'Demo catalog already contains $existingProductsCount products. Skipping.',
      );
      return;
    }

    session.log('Seeding initial demo marketplace data...');

    // Minimal valid 1x1 transparent PNG bytes
    final pngBytes = Uint8List.fromList([
      0x89,
      0x50,
      0x4e,
      0x47,
      0x0d,
      0x0a,
      0x1a,
      0x0a,
      0x00,
      0x00,
      0x00,
      0x0d,
      0x49,
      0x48,
      0x44,
      0x52,
      0x00,
      0x00,
      0x00,
      0x01,
      0x00,
      0x00,
      0x00,
      0x01,
      0x08,
      0x06,
      0x00,
      0x00,
      0x00,
      0x1f,
      0x15,
      0xc4,
      0x89,
      0x00,
      0x00,
      0x00,
      0x0a,
      0x49,
      0x44,
      0x41,
      0x54,
      0x78,
      0x9c,
      0x63,
      0x00,
      0x01,
      0x00,
      0x00,
      0x05,
      0x00,
      0x01,
      0x0d,
      0x0a,
      0x2d,
      0xb4,
      0x00,
      0x00,
      0x00,
      0x00,
      0x49,
      0x45,
      0x4e,
      0x44,
      0xae,
      0x42,
      0x60,
      0x82,
    ]);
    final byteData = ByteData.sublistView(pngBytes);

    // 1. Create demo producers
    final producersData = [
      {
        'name': 'Gurpreet Singh',
        'business': 'Punjab Heritage Handlooms',
        'category': 'Handloom & Textiles',
        'city': 'Amritsar',
        'state': 'Punjab',
        'address': 'Near Heritage Street, Golden Temple, Amritsar',
      },
      {
        'name': 'Rameshwar Prajapati',
        'business': 'Mitti Kala Terracotta Art',
        'category': 'Handicrafts',
        'city': 'Alwar',
        'state': 'Rajasthan',
        'address': 'Potters Colony, Tijara Road, Alwar',
      },
      {
        'name': 'Sunita Devi',
        'business': 'Kashmir Pashmina & Needlework',
        'category': 'Clothing & Embroidery',
        'city': 'Srinagar',
        'state': 'Jammu and Kashmir',
        'address': 'Lal Chowk Craft Lane, Srinagar',
      },
      {
        'name': 'Manoj Kumar',
        'business': 'Vedic Pure Forest Organics',
        'category': 'Food & Homemade Products',
        'city': 'Haridwar',
        'state': 'Uttarakhand',
        'address': 'Rishikesh Highway, Haridwar',
      },
      {
        'name': 'Lakshmi Bai',
        'business': 'Channapatna Heritage Wood Toys',
        'category': 'Woodwork',
        'city': 'Ramanagara',
        'state': 'Karnataka',
        'address': 'Artisan Guild Complex, Channapatna',
      },
      {
        'name': 'Arjan Sharma',
        'business': 'Moradabad Brass Craft Center',
        'category': 'Metal Craft',
        'city': 'Moradabad',
        'state': 'Uttar Pradesh',
        'address': 'Peetal Basti, Moradabad',
      },
    ];

    final createdProducers = <AccountProfile>[];
    for (final p in producersData) {
      final user = await const AuthUsers().create(session);
      final profile = await AccountProfile.db.insertRow(
        session,
        AccountProfile(
          authUserId: user.id,
          displayName: p['name']!,
          role: MarketplaceRole.producer,
          businessName: p['business'],
          craftCategory: p['category'],
          city: p['city'],
          state: p['state'],
          address: p['address'],
          verified: true,
        ),
      );
      createdProducers.add(profile);
    }

    // 2. Create demo buyers
    final buyersData = [
      {'name': 'Rudra Pahuja', 'city': 'New Delhi', 'state': 'Delhi'},
      {'name': 'Ananya Verma', 'city': 'Mumbai', 'state': 'Maharashtra'},
    ];
    final createdBuyers = <AccountProfile>[];
    for (final b in buyersData) {
      final user = await const AuthUsers().create(session);
      final profile = await AccountProfile.db.insertRow(
        session,
        AccountProfile(
          authUserId: user.id,
          displayName: b['name']!,
          role: MarketplaceRole.buyer,
          city: b['city'],
          state: b['state'],
          verified: true,
        ),
      );
      createdBuyers.add(profile);
    }

    // 3. Realistic 20 Products
    final productsCatalog = [
      {
        'producerIdx': 0,
        'name': 'Traditional Phulkari Silk Dupatta',
        'description':
            'Handcrafted pure chanderi dupatta adorned with authentic geometric silk-thread phulkari needlework.',
        'pricePaise': 125000,
        'category': 'Handloom & Textiles',
        'craft': 'Phulkari Embroidery',
        'unit': 'piece',
      },
      {
        'producerIdx': 0,
        'name': 'Handwoven Cotton Khadi Kurta',
        'description':
            'Eco-friendly, breathable handspun khadi kurta dyed using natural extracts for maximum comfort.',
        'pricePaise': 85000,
        'category': 'Clothing & Embroidery',
        'craft': 'Khadi Weaving',
        'unit': 'piece',
      },
      {
        'producerIdx': 0,
        'name': 'Powerloom Jacquard Cotton Bedsheet',
        'description':
            '300 TC long-staple cotton bedsheet woven with intricate Rajasthani floral motifs.',
        'pricePaise': 95000,
        'category': 'Handloom & Textiles',
        'craft': 'Jacquard Weaving',
        'unit': 'set',
      },
      {
        'producerIdx': 1,
        'name': 'Terracotta Water Pitcher (Matka)',
        'description':
            'Natural red clay water dispenser that maintains crisp cool alkaline water organically.',
        'pricePaise': 45000,
        'category': 'Handicrafts',
        'craft': 'Clay Pottery',
        'unit': 'piece',
      },
      {
        'producerIdx': 1,
        'name': 'Hand-painted Ceramic Teacup Set (6pcs)',
        'description':
            'Lead-free microwave-safe glazed clay cups featuring delicate tribal Warli patterns.',
        'pricePaise': 65000,
        'category': 'Handicrafts',
        'craft': 'Ceramic Glazing',
        'unit': 'set',
      },
      {
        'producerIdx': 1,
        'name': 'Traditional Clay Diya Set (Pack of 12)',
        'description':
            'Festive terracotta handmade oil lamps seasoned for high-heat retention.',
        'pricePaise': 25000,
        'category': 'Handicrafts',
        'craft': 'Terracotta Molding',
        'unit': 'pack',
      },
      {
        'producerIdx': 2,
        'name': 'Pure Pashmina Woolen Shawl',
        'description':
            'Featherlight grade-A Cashmere goat wool wrap hand-spun on century-old charkhas.',
        'pricePaise': 350000,
        'category': 'Clothing & Embroidery',
        'craft': 'Pashmina Weaving',
        'unit': 'piece',
      },
      {
        'producerIdx': 2,
        'name': 'Kashmiri Sozni Embroidered Stole',
        'description':
            'Delicate needlepoint chain-stitch embroidery on finest Merino wool base.',
        'pricePaise': 220000,
        'category': 'Clothing & Embroidery',
        'craft': 'Sozni Embroidery',
        'unit': 'piece',
      },
      {
        'producerIdx': 2,
        'name': 'Aari Work Velvet Cushion Covers',
        'description':
            'Lush royal velvet cushions with fine hook embroidery in metallic antique gold.',
        'pricePaise': 80000,
        'category': 'Handloom & Textiles',
        'craft': 'Aari Work',
        'unit': 'pair',
      },
      {
        'producerIdx': 3,
        'name': 'Organic Multi-Flora Raw Honey',
        'description':
            'Unprocessed raw forest honey with natural pollen harvested from Shivalik wildlife sanctuaries.',
        'pricePaise': 45000,
        'category': 'Food & Homemade Products',
        'craft': 'Forest Harvesting',
        'unit': 'jar (500g)',
      },
      {
        'producerIdx': 3,
        'name': 'Pure Desi Sugarcane Jaggery (Gur)',
        'description':
            'Naturally boiled clarifying-agent-free sugarcane jaggery infused with dry ginger and fennel.',
        'pricePaise': 28000,
        'category': 'Food & Homemade Products',
        'craft': 'Artisan Jaggery',
        'unit': 'kg',
      },
      {
        'producerIdx': 3,
        'name': 'Cold-Pressed Yellow Mustard Oil',
        'description':
            'Traditional wooden kohlu extraction preserving natural pungent sinigrin and antioxidants.',
        'pricePaise': 32000,
        'category': 'Food & Homemade Products',
        'craft': 'Cold Press Extraction',
        'unit': 'bottle (1L)',
      },
      {
        'producerIdx': 3,
        'name': 'Sun-dried Punjabi Mango Pickle',
        'description':
            'Crisp raw Ramkela mangoes marinated in cold-pressed mustard oil with whole roasted spices.',
        'pricePaise': 26000,
        'category': 'Food & Homemade Products',
        'craft': 'Artisan Pickling',
        'unit': 'jar (1kg)',
      },
      {
        'producerIdx': 4,
        'name': 'Channapatna Wooden Toy Train',
        'description':
            'Non-toxic vegetable lac coated Wrightia tinctoria ivory-wood classic train engine.',
        'pricePaise': 65000,
        'category': 'Woodwork',
        'craft': 'Channapatna Woodcraft',
        'unit': 'piece',
      },
      {
        'producerIdx': 4,
        'name': 'Carved Sheesham Wood Spice Box',
        'description':
            'Hand-lathed North Indian rosewood circular 7-container masala box with glass lid.',
        'pricePaise': 89000,
        'category': 'Woodwork',
        'craft': 'Wood Joinery',
        'unit': 'piece',
      },
      {
        'producerIdx': 4,
        'name': 'Teakwood Cutlery & Serving Spoons',
        'description':
            'Ergonomic water-resistant seasoned teak serving set finished with virgin coconut oil.',
        'pricePaise': 42000,
        'category': 'Woodwork',
        'craft': 'Wood Carving',
        'unit': 'set',
      },
      {
        'producerIdx': 5,
        'name': 'Hand-hammered Brass Cooking Kadhai',
        'description':
            'Thick heavy-bottom traditional brass wok lined with pure food-grade tin (kalai).',
        'pricePaise': 185000,
        'category': 'Metal Craft',
        'craft': 'Metal Hammering',
        'unit': 'piece',
      },
      {
        'producerIdx': 5,
        'name': 'Dhokra Lost-Wax Bell Metal Elephant',
        'description':
            'Primitive tribal lost-wax cast alloy figurine sculpted by Bastar craftspeople.',
        'pricePaise': 110000,
        'category': 'Metal Craft',
        'craft': 'Dhokra Casting',
        'unit': 'piece',
      },
      {
        'producerIdx': 5,
        'name': 'Pure Copper Water Bottle & Cups',
        'description':
            'Ayurvedic jointless 99.8% copper vessel offering natural mineral ionization.',
        'pricePaise': 95000,
        'category': 'Metal Craft',
        'craft': 'Copper Spinning',
        'unit': 'set',
      },
      {
        'producerIdx': 5,
        'name': 'Bronze Heritage Pooja Thali Set',
        'description':
            'Acoustic resonant kansa bell-metal prayer tray with embossed auspicious motifs.',
        'pricePaise': 160000,
        'category': 'Metal Craft',
        'craft': 'Kansa Metalwork',
        'unit': 'set',
      },
    ];

    final imageCache = <String, ByteData?>{};
    for (var index = 0; index < productsCatalog.length; index++) {
      final item = productsCatalog[index];
      final producer = createdProducers[item['producerIdx'] as int];
      final product = await Product.db.insertRow(
        session,
        Product(
          producerProfileId: producer.id!,
          name: item['name'] as String,
          description: item['description'] as String,
          pricePaise: item['pricePaise'] as int,
          category: item['category'] as String,
          craft: item['craft'] as String,
          unit: item['unit'] as String,
          minimumOrderQuantity: [5, 10, 25, 50][index % 4],
          city: producer.city,
          state: producer.state,
          status: ProductStatus.published,
        ),
      );

      final photoBytes =
          await _imageFor(session, item['name'] as String, imageCache) ??
          byteData;
      await ProductPhoto.db.insertRow(
        session,
        ProductPhoto(productId: product.id!, bytes: photoBytes),
      );
    }

    // 4. Initial Buyer Requirements
    final buyer1 = createdBuyers[0];
    final reqs = [
      BuyerRequirement(
        buyerProfileId: buyer1.id!,
        title: 'Requirement for Phulkari Dupattas for Festive Gifting',
        description:
            'Looking for 50 pieces of authentic hand-embroidered Phulkari dupattas. Premium finish for corporate gifting.',
        category: 'Handloom & Textiles',
        quantity: 50,
        budgetPaise: 4500000,
        city: 'New Delhi',
        state: 'Delhi',
        status: 'open',
        createdAt: DateTime.now().toUtc(),
      ),
      BuyerRequirement(
        buyerProfileId: buyer1.id!,
        title: 'Organic Honey Bulk Procurement',
        description:
            'Seeking 200 bottles (500g each) of certified raw forest honey for health food retail chain.',
        category: 'Food & Homemade Products',
        quantity: 200,
        budgetPaise: 6500000,
        city: 'New Delhi',
        state: 'Delhi',
        status: 'open',
        createdAt: DateTime.now().toUtc(),
      ),
      BuyerRequirement(
        buyerProfileId: buyer1.id!,
        title: 'Terracotta Diyas for Diwali Corporate Gifting',
        description:
            'Need 500 hand-painted terracotta diyas with custom packaging for a corporate Diwali hamper.',
        category: 'Handicrafts',
        quantity: 500,
        budgetPaise: 9000000,
        city: 'New Delhi',
        state: 'Delhi',
        status: 'open',
        createdAt: DateTime.now().toUtc(),
      ),
      BuyerRequirement(
        buyerProfileId: buyer1.id!,
        title: 'Channapatna Wooden Toys for Retail Chain',
        description:
            'Sourcing 300 non-toxic wooden toys in assorted designs for a children gifting range.',
        category: 'Woodwork',
        quantity: 300,
        budgetPaise: 15000000,
        city: 'New Delhi',
        state: 'Delhi',
        status: 'open',
        createdAt: DateTime.now().toUtc(),
      ),
      BuyerRequirement(
        buyerProfileId: buyer1.id!,
        title: 'Brass Kadhais for Restaurant Supply',
        description:
            'Looking for 100 food-grade tin-lined brass kadhais in 2 litre and 3 litre sizes.',
        category: 'Metal Craft',
        quantity: 100,
        budgetPaise: 12000000,
        city: 'New Delhi',
        state: 'Delhi',
        status: 'open',
        createdAt: DateTime.now().toUtc(),
      ),
    ];
    for (final req in reqs) {
      await BuyerRequirement.db.insertRow(session, req);
    }

    session.log(
      'Successfully seeded 6 producers, 2 buyers, 20 products, and 5 buyer requirements!',
    );
  } catch (e, stack) {
    session.log(
      'Error during data seeding: $e',
      level: LogLevel.error,
      stackTrace: stack,
    );
  } finally {
    await session.close();
  }
}

/// Returns the photo for [name], caching downloads so repeated category images
/// are fetched only once. Falls back to a known-good image, then null.
Future<ByteData?> _imageFor(
  Session session,
  String name,
  Map<String, ByteData?> cache,
) async {
  final url = _productImages[name] ?? _fallbackImage;
  if (cache.containsKey(url)) return cache[url];

  var bytes = await _downloadImage(url);
  if (bytes == null && url != _fallbackImage) {
    if (cache.containsKey(_fallbackImage)) {
      bytes = cache[_fallbackImage];
    } else {
      bytes = await _downloadImage(_fallbackImage);
      cache[_fallbackImage] = bytes;
    }
  }
  cache[url] = bytes;
  if (bytes != null) {
    session.log(
      'Fetched demo image for "$name" (${bytes.lengthInBytes} bytes).',
    );
  } else {
    session.log(
      'Could not fetch a demo image for "$name".',
      level: LogLevel.warning,
    );
  }
  return bytes;
}

Future<ByteData?> _downloadImage(String url) async {
  final client = HttpClient()..connectionTimeout = const Duration(seconds: 6);
  try {
    final request = await client.getUrl(Uri.parse(url));
    request.headers.set(
      HttpHeaders.userAgentHeader,
      'VyaparSetuSeeder/1.0 (+https://vyaparsetu.serverpod.space)',
    );
    final response = await request.close().timeout(const Duration(seconds: 12));
    if (response.statusCode != HttpStatus.ok) return null;
    final builder = BytesBuilder(copy: false);
    await for (final chunk in response.timeout(const Duration(seconds: 12))) {
      builder.add(chunk);
    }
    final bytes = builder.takeBytes();
    if (bytes.lengthInBytes < 2048) return null;
    return ByteData.sublistView(bytes);
  } catch (_) {
    return null;
  } finally {
    client.close(force: true);
  }
}
