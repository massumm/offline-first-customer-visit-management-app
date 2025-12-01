import 'package:flutter/material.dart';

class CommunitySpotlightCard extends StatelessWidget {
  const CommunitySpotlightCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Flexible(
                child: Text(
                  "Community Spotlight",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.close, size: 20, color: Colors.grey[700]),
            ],
          ),

          const SizedBox(height: 12),

          /// Avatars + arrow
          Row(
            children: [
              Flexible(
                child: _buildAvatarStack(),
              ),
              const Spacer(),
              Icon(Icons.arrow_outward, color: Colors.redAccent, size: 20),
            ],
          ),

          const SizedBox(height: 12),

          /// Title
          const Text(
            "5 friends joined the ‘August Streak Challenge’",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          /// Subtitle
          const Text(
            "Your friend Jordan just logged a new PR: 100kg Bench Press.",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  /// Overlapping Avatars
  Widget _buildAvatarStack() {
    final avatars = [
      "https://i.pravatar.cc/150?img=1",
      "https://i.pravatar.cc/150?img=2",
      "https://i.pravatar.cc/150?img=3",
      "https://i.pravatar.cc/150?img=4",
      "https://i.pravatar.cc/150?img=5",
    ];

    return SizedBox(
      height: 34,
      child: Stack(
        children: [
          for (int i = 0; i < avatars.length; i++)
            Positioned(
              left: i * 22.0,
              child: CircleAvatar(
                radius: 17,
                backgroundImage: NetworkImage(avatars[i]),
              ),
            ),
        ],
      ),
    );
  }
}
