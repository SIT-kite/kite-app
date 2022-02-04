/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
class Constants {
  static const homeUrl = 'http://210.35.66.106';
  static const opacUrl = homeUrl + '/opac';
  static const searchUrl = opacUrl + '/search';
  static const hotSearchUrl = opacUrl + '/hotsearch';
  static const apiUrl = opacUrl + '/api';
  static const bookUrl = opacUrl + '/book';
  static const bookHoldingUrl = apiUrl + '/holding';
  static const bookHoldingPreviewsUrl = bookUrl + '/holdingPreviews';
  static const virtualBookshelfUrl = apiUrl + '/virtualBookshelf';
  static const bookImageInfoUrl = 'https://book-resource.dataesb.com/websearch/metares';
}
