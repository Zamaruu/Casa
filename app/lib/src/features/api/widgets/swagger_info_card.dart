import 'package:casa/src/core/api/api_service.dart';
import 'package:casa/src/core/constants/svg.constants.dart';
import 'package:casa/src/core/services/service_locator.dart';
import 'package:casa/src/core/utils/launcher.util.dart';
import 'package:casa/src/widgets/base/text.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SwaggerInfoCard extends StatelessWidget {
  const SwaggerInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Builder(
        builder: (context) {
          final launcher = const LauncherUtil();
          final url = services.get<ApiServiceManager>().url;
          final swaggerUrl = "$url/swagger/ui";

          return ListTile(
            leading: SvgPicture.asset(
              kSwaggerLogoSvg,
              semanticsLabel: 'Swagger Logo',
              colorFilter: ColorFilter.mode(Color(0xFF49a22b), BlendMode.srcIn),
            ),
            title: const CasaText("Swagger OpenAPI Documentation"),
            subtitle: CasaText(swaggerUrl),

            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    final specsUrl = "$url/swagger/specs";
                    launcher.launchWebsite(context: context, url: specsUrl);
                  },
                  icon: Icon(Icons.code),
                  tooltip: "Swagger Specs öffnen",
                ),
                IconButton(
                  onPressed: () {
                    launcher.launchWebsite(context: context, url: swaggerUrl);
                  },
                  icon: Icon(Icons.open_in_new),
                  tooltip: "Swagger UI öffnen",
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
