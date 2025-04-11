import 'package:base_code_flutter/utils/helper_utils.dart';
import 'package:flutter/cupertino.dart';


class NoDataWidget extends StatelessWidget {
  final ConnectionState? connectionState;
  final Widget? icon;
  final String? desc;
  final bool? isLoading;
  final List<Widget>? bottomWidgets;
  const NoDataWidget({super.key, this.connectionState = ConnectionState.active, this.isLoading, this.icon, this.desc, this.bottomWidgets});

  @override
  Widget build(BuildContext context) {
    if (isLoading == true || connectionState != ConnectionState.active) {
      return const SizedBox();
    }
    return Center(
      child: _buildNoDataWidget(context),
    );
  }

  Widget _buildNoDataWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon ?? Image.asset("assets/image/nodata.png", width: 250,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 10),
          child: Text(
            desc ?? "Không có kết quả nào được tìm thấy",
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium,
          ),
        ),
        if (bottomWidgets != null)
          ...bottomWidgets!,
      ],
    );
  }
}
