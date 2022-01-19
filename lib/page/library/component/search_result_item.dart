import 'package:flutter/material.dart';
import 'package:kite/util/library/search.dart';
import 'package:kite/util/logger.dart';

class BookItemWidget extends StatelessWidget {
  final BookImageHolding bookImageHolding;

  final GestureTapCallback? onAuthorTap;
  const BookItemWidget(this.bookImageHolding, {Key? key, this.onAuthorTap}) : super(key: key);

  /// 构造图书封皮预览图片
  Widget buildBookCover(String? imageUrl) {
    const def = Icon(
      Icons.library_books_sharp,
      size: 100,
    );
    if (imageUrl == null) {
      return def;
    }

    return Image.network(
      imageUrl,
      // fit: BoxFit.fill,
      errorBuilder: (
        BuildContext context,
        Object error,
        StackTrace? stackTrace,
      ) {
        return def;
      },
    );
  }

  /// 构造一个图书项
  Widget buildListTile(BuildContext context, BookImageHolding bi) {
    final screenHeight = MediaQuery.of(context).size.height;
    Log.info('屏幕高度: $screenHeight');
    final book = bi.book;
    final holding = bi.holding ?? [];
    // 计算总共馆藏多少书
    int copyCount = holding.map((e) => e.copyCount).reduce((value, element) => value + element);
    // 计算总共可借多少书
    int loanableCount = holding.map((e) => e.loanableCount).reduce((value, element) => value + element);
    final row = Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(5),
            child: buildBookCover(bi.image?.resourceLink),
            height: screenHeight / 5,
          ),
          flex: 3,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                book.title,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onAuthorTap == null
                  ? Text('作者:  ${book.author}')
                  : Row(
                      children: [
                        const Text('作者:  '),
                        InkWell(
                          child: Text(
                            book.author,
                            style: const TextStyle(color: Colors.blue),
                          ),
                          onTap: onAuthorTap,
                        ),
                      ],
                    ),
              Text('索书号:  ${book.callNo}'),
              Text('ISBN:  ${book.isbn}'),
              Text('${book.publisher}  ${book.publishDate}'),
              Row(
                children: [
                  const Expanded(child: Text(' ')),
                  ColoredBox(
                    color: Colors.black12,
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
                      // width: 80,
                      // height: 20,
                      child: Text('馆藏($copyCount)/在馆($loanableCount)'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          flex: 7,
        ),
      ],
    );
    return row;
  }

  @override
  Widget build(BuildContext context) {
    return buildListTile(context, bookImageHolding);
  }
}
