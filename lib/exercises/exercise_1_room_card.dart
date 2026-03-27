import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

String formatCount(int count) {
  if (count < 1000) return count.toString();
  if (count < 1000000) {
    double value = count / 1000;
    return '${value.toStringAsFixed(value % 1 == 0 ? 0 : 1)}K';
  }
  double value = count / 1000000;
  return '${value.toStringAsFixed(value % 1 == 0 ? 0 : 1)}M';
}

class RoomEntity {
  final int id;
  final String roomName;
  final String? roomIntro;
  final String? coverUrl;
  final int visitorsCount;
  final String? countryFlag;
  final bool isLive;
  final bool hasPassword;
  final String? ownerName;
  final String? ownerAvatarUrl;

  const RoomEntity({
    required this.id,
    required this.roomName,
    this.roomIntro,
    this.coverUrl,
    this.visitorsCount = 0,
    this.countryFlag,
    this.isLive = false,
    this.hasPassword = false,
    this.ownerName,
    this.ownerAvatarUrl,
  });
}

final sampleRooms = [
  const RoomEntity(
    id: 1,
    roomName: 'Welcome to the Super Amazing Party Room 🎉🎉🎉',
    roomIntro: 'Join us for music and fun! Everyone is welcome.',
    coverUrl: 'https://picsum.photos/200/200',
    visitorsCount: 1234,
    countryFlag: '🇺🇸',
    isLive: true,
    hasPassword: false,
    ownerName: 'DJ_Master',
    ownerAvatarUrl: 'https://picsum.photos/50/50',
  ),
  const RoomEntity(
    id: 2,
    roomName: 'Chill Zone',
    roomIntro: null,
    coverUrl: null,
    visitorsCount: 0,
    countryFlag: '🇹🇷',
    isLive: false,
    hasPassword: true,
    ownerName: 'Relaxer',
  ),
  const RoomEntity(
    id: 3,
    roomName: 'Gaming Arena - Competitive Matches Every Hour - Join Now!',
    roomIntro:
        'Competitive gaming room with hourly tournaments and prizes for top players',
    coverUrl: 'https://picsum.photos/200/201',
    visitorsCount: 56789,
    countryFlag: null,
    isLive: true,
    hasPassword: false,
  ),
];

// extracted image widget so RoomCard stays clean
class CachedImage extends StatelessWidget {
  final String? url;
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final BoxFit fit;

  const CachedImage({
    super.key,
    required this.url,
    required this.width,
    required this.height,
    this.borderRadius = BorderRadius.zero,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    // RepaintBoundary so image repaints don't affect the rest of the card
    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: borderRadius,
        child: SizedBox(
          width: width,
          height: height,
          child: url != null
              ? CachedNetworkImage(
                  imageUrl: url!,
                  fit: fit,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: AppColors.shimmerBase,
                    highlightColor: AppColors.shimmerHighlight,
                    child: Container(color: Colors.white),
                  ),
                  errorWidget: (context, url, error) => const ColoredBox(
                    color: AppColors.greyText,
                    child: Icon(Icons.broken_image, color: Colors.white),
                  ),
                )
              : const ColoredBox(
                  color: AppColors.greyText,
                  child: Icon(Icons.image, color: Colors.white),
                ),
        ),
      ),
    );
  }
}

class RoomCardList extends StatelessWidget {
  const RoomCardList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rooms')),
      body: ListView.builder(
        itemCount: sampleRooms.length,
        itemBuilder: (context, index) => RoomCard(
          key: ValueKey(sampleRooms[index].id),
          room: sampleRooms[index],
        ),
      ),
    );
  }
}

class RoomCard extends StatelessWidget {
  final RoomEntity room;

  const RoomCard({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    // RepaintBoundary per card so one card redraw doesn't repaint the whole list
    return RepaintBoundary(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CachedImage(
                  url: room.coverUrl,
                  width: 80.w,
                  height: 80.w,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                if (room.isLive)
                  Positioned(
                    top: 4,
                    left: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'LIVE',
                        style: TextStyle(color: Colors.white, fontSize: 8),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          room.roomName,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      _VisitorCount(count: room.visitorsCount),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  // only show intro if it's not null/empty
                  if (room.roomIntro != null && room.roomIntro!.isNotEmpty)
                    Text(
                      room.roomIntro!,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.greyText,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      if (room.countryFlag != null)
                        Text(
                          room.countryFlag!,
                          style: TextStyle(fontSize: 16.sp),
                        ),
                      if (room.countryFlag != null && room.hasPassword)
                        SizedBox(width: 6.w),
                      if (room.hasPassword)
                        Icon(
                          Icons.lock,
                          size: 14.r,
                          color: AppColors.primary,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VisitorCount extends StatelessWidget {
  final int count;

  const _VisitorCount({required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.visibility, size: 12.r, color: Colors.grey),
        SizedBox(width: 2.w),
        Text(
          formatCount(count),
          style: TextStyle(fontSize: 10.sp, color: Colors.grey),
        ),
      ],
    );
  }
}

class AppColors {
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static const greyText = Color(0xFFa5a7a4);
  static const primary = Color(0xFF32e5ac);
  static const shimmerBase = Color(0xFFE0E0E0);
  static const shimmerHighlight = Color(0xFFF5F5F5);
}
