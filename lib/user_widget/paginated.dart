import 'package:flutter/material.dart';

// steal from "https://github.com/Akifcan/flutter_pagination"
class Paginated extends StatefulWidget {
  final PaginateSkipButton prevButtonStyles;
  final PaginateSkipButton nextButtonStyles;
  final PaginateButtonStyles paginateButtonStyles;
  final bool useSkipAndPrevButtons;
  final bool useGroup;
  final int currentPage;
  final int totalPage;
  final int show;
  final double? width;
  final double? height;
  final Function(int number) onPageChange;

  const Paginated(
      {Key? key,
      this.width,
      this.height,
      this.useGroup = false,
      this.useSkipAndPrevButtons = true,
      required this.prevButtonStyles,
      required this.nextButtonStyles,
      required this.paginateButtonStyles,
      required this.onPageChange,
      required this.totalPage,
      required this.show,
      required this.currentPage})
      : super(key: key);

  @override
  State<Paginated> createState() => _PaginatedState();
}

class _PaginatedState extends State<Paginated> {
  late PageController pageController;
  List<int> pages = [];
  List<int> nextPages = [];
  List<int> prevPages = [];
  List<List<int>> groupedPages = [];
  double defaultHeight = 50;

  void nonGroupPaginate() {
    setState(() {
      pages = [];
      nextPages = [];
      prevPages = [];
      for (int i = 0; i < widget.totalPage; i++) {
        pages.add(i);
      }
      for (int i = 0; i < widget.show; i++) {
        if (pages.asMap().containsKey(widget.currentPage + i)) {
          nextPages.add(pages[widget.currentPage + i]);
        }
      }
      for (int i = widget.show; i > 0; i--) {
        if (widget.currentPage - i - 1 > 0) {
          prevPages.add(pages[widget.currentPage - i - 1]);
        }
      }
    });
  }

  void groupPaginate() {
    int lastIndex = 0;
    int counter = 0;
    setState(() {
      groupedPages = [];
      pages = [];
      for (int i = 0; i < widget.totalPage; i++) {
        pages.add(i);
      }
      for (int j = 0; j < pages.length; j++) {
        counter++;
        if (counter == widget.show) {
          int next = lastIndex + widget.show;
          groupedPages.add(pages.sublist(lastIndex, next < pages.length ? next : pages.length));
          counter = 0;
          lastIndex += widget.show;
        }
      }
      groupedPages.add(pages.sublist(lastIndex));
    });
  }

  void initialize() {
    if (!widget.useGroup) {
      nonGroupPaginate();
    } else {
      groupPaginate();
      pageController = PageController();
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.show < widget.totalPage, "Show count should be smaller than total page");
    initialize();
    return !widget.useGroup ? nonGrouppedChild : grouppedChild;
  }

  Widget get grouppedChild => SizedBox(
        width: widget.width ?? MediaQuery.of(context).size.width,
        height: 60,
        child: Row(
          children: [
            if (widget.useSkipAndPrevButtons)
              SkipButton(
                buttonStyles: widget.prevButtonStyles,
                height: widget.height ?? defaultHeight,
                onTap: () {
                  pageController.previousPage(duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
                },
                skipButtonType: SkipButtonType.prev,
              ),
            Expanded(
                child: PageView.builder(
                    controller: pageController,
                    itemCount: groupedPages.where((element) => element.isNotEmpty).length,
                    itemBuilder: (_, index) {
                      return Row(
                        children: groupedPages[index].map((e) {
                          return Expanded(
                              child: PaginateButton(
                                  active: widget.currentPage == e + 1,
                                  buttonStyles: widget.paginateButtonStyles,
                                  height: widget.height ?? defaultHeight,
                                  page: e + 1,
                                  color: e + 1 == widget.currentPage ? Colors.blueGrey : Colors.blue,
                                  onTap: (number) {
                                    widget.onPageChange(number);
                                  }));
                        }).toList(),
                      );
                    })),
            if (widget.useSkipAndPrevButtons)
              SkipButton(
                buttonStyles: widget.nextButtonStyles,
                height: widget.height ?? defaultHeight,
                onTap: () {
                  pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
                },
                skipButtonType: SkipButtonType.next,
              ),
          ],
        ),
      );

  Widget get nonGrouppedChild => Wrap(
        children: [
          if (widget.useSkipAndPrevButtons)
            SkipButton(
              buttonStyles: widget.prevButtonStyles,
              height: widget.height ?? defaultHeight,
              onTap: () {
                if (widget.currentPage != 1) {
                  int current = widget.currentPage;
                  widget.onPageChange(current -= 1);
                }
              },
              skipButtonType: SkipButtonType.prev,
            ),
          for (int i = 0; i < prevPages.length; i++)
            PaginateButton(
                active: false,
                width: 50,
                buttonStyles: widget.paginateButtonStyles,
                height: widget.height ?? defaultHeight,
                onTap: (number) {
                  widget.onPageChange(number);
                },
                page: prevPages[i] + 1,
                color: Colors.blue),
          PaginateButton(
              active: true,
              width: 50,
              buttonStyles: widget.paginateButtonStyles,
              height: widget.height ?? defaultHeight,
              onTap: (number) {
                widget.onPageChange(widget.currentPage);
              },
              page: widget.currentPage,
              color: Colors.blueGrey[800]!),
          for (int i = 0; i < nextPages.length; i++)
            PaginateButton(
                active: false,
                width: 50,
                buttonStyles: widget.paginateButtonStyles,
                height: widget.height ?? defaultHeight,
                onTap: (number) {
                  widget.onPageChange(number);
                },
                page: nextPages[i] + 1,
                color: Colors.blue),
          if (widget.useSkipAndPrevButtons)
            SkipButton(
              buttonStyles: widget.nextButtonStyles,
              height: widget.height ?? defaultHeight,
              onTap: () {
                if (widget.currentPage + 1 <= widget.totalPage) {
                  int current = widget.currentPage;
                  widget.onPageChange(current += 1);
                }
              },
              skipButtonType: SkipButtonType.next,
            ),
        ],
      );
}

enum SkipButtonType { prev, next }

class SkipButton extends StatelessWidget {
  final PaginateSkipButton buttonStyles;
  final double height;
  final SkipButtonType skipButtonType;
  final VoidCallback onTap;

  const SkipButton(
      {Key? key, required this.buttonStyles, required this.height, required this.skipButtonType, required this.onTap})
      : super(key: key);

  final double radius = 20;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ClipRRect(
        borderRadius: buttonStyles.getBorderRadius,
        child: Material(
          color: buttonStyles.getButtonBackgroundColor,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: skipButtonType == SkipButtonType.prev
                  ? buttonStyles.icon ?? const Icon(Icons.chevron_left, color: Colors.white, size: 35)
                  : buttonStyles.icon ?? const Icon(Icons.chevron_right, color: Colors.white, size: 35),
            ),
          ),
        ),
      ),
    );
  }
}

class PaginateButton extends StatelessWidget {
  final bool active;
  final double height;
  final double? width;
  final int page;
  final Color color;
  final Function(int number) onTap;
  final PaginateButtonStyles buttonStyles;

  const PaginateButton(
      {Key? key,
      required this.active,
      this.width,
      required this.buttonStyles,
      required this.page,
      required this.height,
      required this.color,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: buttonStyles.getPaginateButtonBorderRadius,
      child: SizedBox(
        height: height,
        width: width ?? MediaQuery.of(context).size.width,
        child: Material(
          color: active ? buttonStyles.getActiveBackgroundColor : buttonStyles.getBackgroundColor,
          child: InkWell(
            onTap: () {
              onTap(page);
            },
            child: Center(
              child: Text("$page",
                  style: active ? buttonStyles.getActiveTextStyle : buttonStyles.getTextStyle,
                  textAlign: TextAlign.center),
            ),
          ),
        ),
      ),
    );
  }
}

class PaginateButtonStyles {
  final double? fontSize;
  final BorderRadius? paginateButtonBorderRadius;
  final Color? backgroundColor;
  final Color? activeBackgroundColor;
  final TextStyle? textStyle;
  final TextStyle? activeTextStyle;

  PaginateButtonStyles(
      {this.fontSize,
      this.backgroundColor,
      this.activeBackgroundColor,
      this.paginateButtonBorderRadius,
      this.textStyle,
      this.activeTextStyle});

  double get getFontSize {
    return fontSize ?? 14.0;
  }

  Color get getBackgroundColor {
    return backgroundColor ?? Colors.blue;
  }

  Color get getActiveBackgroundColor {
    return activeBackgroundColor ?? Colors.blueGrey;
  }

  TextStyle get getTextStyle {
    return textStyle ?? const TextStyle(color: Colors.white, fontFamily: 'Roboto', fontSize: 14);
  }

  TextStyle get getActiveTextStyle {
    return activeTextStyle ?? const TextStyle(color: Colors.white, fontFamily: 'Roboto', fontSize: 14);
  }

  BorderRadius get getPaginateButtonBorderRadius {
    return paginateButtonBorderRadius ?? BorderRadius.circular(0);
  }
}

class PaginateSkipButton extends PaginateButtonStyles {
  final Icon? icon;
  final BorderRadius? borderRadius;
  final Color? buttonBackgroundColor;

  PaginateSkipButton({this.icon, this.borderRadius, this.buttonBackgroundColor});

  BorderRadius get getBorderRadius {
    return borderRadius ?? BorderRadius.zero;
  }

  Color get getButtonBackgroundColor {
    return buttonBackgroundColor ?? Colors.blue;
  }
}
