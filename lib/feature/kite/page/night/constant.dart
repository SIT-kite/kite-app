/*
 * 上应小风筝  便利校园，一步到位
 * Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'dart:math';

const text = [
  '缘起，在人群中，我看见你；缘灭，我看见你，在人群中。',
  '世间最珍贵的不是“得不到”和“已失去”，而是现在能把握的幸福。',
  '我们太忙于低头赶路，以致错过了太多美好的风景。',
  '无须匆忙，该来的总会来，在对的时间，和对的人，因为对的理由。',
  '有些人到此为止。有些事由不得你。',
  '时间不早了，赶紧睡觉呗，明天咱们在聊，爱你哦！',
  '我真的太喜欢熬夜了，我觉得我上辈子就是个路灯。',
  '晚安，睡觉吧。不然我待会儿又要想你了。',
  '你还年轻，别凑活过。没事早点睡，有空多挣钱，少想七想八的。',
  '从来茶倒七分满，留下三分是人情；有些关系，断了就让它断了，好聚好散，各自安好。',
  '生活平凡，但每一天都是限量版，在平淡中寻找一份欢喜，把日子过成诗。',
  '我的每一支笔，都知道你的名字。',
  '人生路上的过客很多，每个人都有各自的终点，他们向东西南北，而我向你。',
  '人情世故的事，既然无法周全所有人，就只能周全自己了。',
  '放弃不难，但坚持一定很酷。',
  '别再熬夜了，醒来一定会更熟一点儿。',
  '如果你决定旅行，就别怕风雨兼程。',
  '好好体会生命的每一天，因为只有今生，没有来世。',
  '不努力，谁也给不了你想要的生活，',
  '无论你觉得自己多么的不幸，永远有人比你更加不幸，',
  '熬得住，出众；熬不住，出局，这就是人生。',
  '不敢奢求有锦鲤般的运气，但求一切顺利，长路漫漫，未来可期。',
  '睡个好觉，明天睁开眼睛你就会看到我了。',
  '行百里者半九十，成功的路上从来不堵车。想过自律的人生，就请从早起开始吧。',
  '问题越重大，答案就越不可能一成不变。',
  '与有肝胆的人共事，从无字句处读书，',
  '人之所以有一张嘴，而有两只耳朵，原因是听的要比说的多一倍。',
  '他有多好，是他的；他对你有多好，才属于你的。',
  '何必向不值得的人证明什么，生活得更好，乃是为你自己。',
  '所谓成熟，不过是更加能忍耐痛苦罢了。',
  '你必须要努力，不然过了一年十年，还是那个糟糕又没钱的自己。',
  '心有多远，你就能走多远，做一个温暖的人，浅浅笑，轻轻爱。',
  '世界上所有的惊喜和好运，都是你累积的温柔和善良。',
  '酸甜苦辣我自己尝，喜怒哀乐我自己扛；我就是自己的太阳，无须凭借谁的光。',
  '人丑就要多读书，不负好时光；生活总是给予我们，不大不小的期待和馈赠。',
  '年少已过，轻狂不再；不惧过去，不畏将来。',
  '命运不是机遇，而是一种选择；它不是我们要等待的东西，而是我们要实现的东西。',
  '与有肝胆的人共事，从无字句处读书，',
  '把平凡的小事做到极致，也是一种强大的超能力。',
  '早安，是换个时间想你；午安，是换个方向想你；晚安，是换个世界想你。',
  '快乐不代表每件事都完美，而是你已下定决心让眼界超越不完美。',
  '我梦想中的生活就是这样：有花，有天空，有可以眺望期许的远方。',
  '因为，约还没有赴，你还没有见着，事还没有成。所以，为之千千万万遍努力。',
  '愿时光里所有的温柔事物，都在这个美好的九月如期而至。',
  '什么都想要，什么都失掉。若是握不住的沙，那就干脆扬了它，为自己的生活减轻负担，',
  '过年想去你家拜年，然后领你爸妈的压岁钱。',
  '希望世界安静，让所有情绪都见鬼。',
  '只要内心不乱，外界就很难改变你什么。不要艳羡他人，不要输掉自己。',
  '人，少点承诺，多点实际。别嘴上一套，背后一套。',
  '即使你任性，敏感，爱挑剔，他依然和你说：做你自己、我来爱你，这就是最好的爱情。',
  '如果心胸不似海，又怎能有海一样的事业。',
  '人间事往往如此，当时提起痛不欲生，几年之后，也不过是一场回忆而已。',
  '宁可被人笑一时，不可被人笑一辈子。',
  '一个不确定的明天，一个不知道的未来，突然好迷茫，但是要学会坚持。',
  '我是个很懒的人，连路都懒得走，可是不管走多少公里，我都想去你心里，住一辈子。',
  '失败的是事，绝不应是人，',
  '梦就像星星一样多，却也像星星一样遥远。',
  '我们一步一步走下去，踏踏实实地去走，永不抗拒生命交给我们的重负，才是一个勇者。',
  '山外青山楼外楼，江山不及你温柔。',
  '宝贝，晚安，祝你做个美梦，最好梦里有我。',
  '当你快乐的时候，生活就是美好的。',
  '生活不如你意，我如你意，运气不在你身边，我在你身边。',
  '屏幕前的孩子，你要吃饱，要早睡，不要仗着自己长得美，就可以随意熬夜。',
  '不能样样胜利，但可以事事尽力。',
  '应该努力的生活，往事不提后事不记。愿你，常开心，常欣喜，有趣，有盼，无灾，无难。',
  '去找一个像太阳一样的人，帮你晒晒所有不值一提的迷茫。',
  '想陪你，在雪山上捞月亮张网捕星光，摘一缕清风下酒喝一碗旧时光。',
  '学会宽容，要有一颗宽容的爱心！',
  '不谈以前的艰难，只论现在的坚持。人生就像舞台，不到谢幕，永远不要认输！',
  '一个人吃一顿丰盛的大餐，也不如两个人吃一碗泡面来的幸福。',
  '你今天的努力，是幸运的伏笔。当下的付出，是明日的花开。',
  '如果做不到对别人狠，那就对自己狠一点，你逼自己变强大了，也就没有人敢对你狠了。',
  '我贪恋的人间烟火，不偏不倚，刚好是你，晚安，余生是你。',
  '每天收获小进步，积累起来就是大进步；每天收获小幸福，积攒起来便成大幸福。',
  '一个人知道为什么而活，就可以从容面对任何生活难题。',
  '不要放弃心里的希望，希望就如一片土壤，能生长出许多美好。',
  '睡觉吧，你的头发不允许你瞎想。',
  '烦恼又不给一分钱的报酬，何苦去替它履行什么，',
  '生命中，再无聊的时光，也都是限量版，所以，从此刻起珍惜时间吧，不虚度每一天。',
  '给事物赋予什么样的价值，人们就有什么样的行动。',
  '余生很长，愿你拥抱自己，努力成长，眼里长着太阳，笑里全是坦荡。',
  '愿你以后的生活是：不为难自己，不辜负岁月。时光，浓淡相宜；人心，远近相安。',
  '你今天的苦果，是昨天的伏笔，当下的付出，是明日的花开。',
  '愿你，冬来温雪，夏来赏荷，春煮清茶，秋着布衣，四季就是前路，生活即是江湖。',
  '再难的时候，也要对周围笑一笑。没有一个人会一直生活在春天的阳光下，季节还会忽冷忽热呢，何况运气和心情。',
  '安静欣赏夜景，将喧闹归零;慢慢喝杯牛奶，将忙碌归零;清除痛苦的记忆，将压力归零。夜晚一刻，祝福升级，烦恼归零。',
  '没有结局的故事太多，你要习惯相遇与离别。岁月会记得，你温柔赤诚的心。',
  '虽然我们要为了生活和梦想不断奔波，可是我们无所惧怕，因为我们知道--爱，会一向在那里！',
  '就算这世界有太多的失望，希望你能试着接受，并且学着不为难自己。愿你一直单纯、勇敢，相信爱。',
  '星星亮着，夜空就不会黑暗；问候伴着，心灵就不会孤单；祝福传递，温暖送给你。愿你今晚有个好梦。',
  '慢慢变好，才是给自己最好的礼物。愿你是能披荆斩棘的女英雄，也是被人疼爱的小朋友。',
  '不管雨下多久，最终彩虹总会出现。不管你有多难过，始终要相信，幸福就在不远处。',
  '这样安静的世界真好，在这世界中能寻得一处既可养活自己，又能与世界脱离的独处，真的好。',
  '最幸福的莫过于：在最让人羡慕的年纪活成了自己曾经最憧憬的样子。',
  '你勤奋充电，你努力工作，你保持身材，你对人微笑，这些都不是为了取悦他人，而是为了扮靓自己，照亮自己的心，告诉自己：我是一股独立向上的力量。',
  '乖乖，你看那月牙已上树梢，你听那蝉虫也已熄声，天不早了，早点歇息，掖好被子不准乱踢。',
  '思念不因劳累而改变，问候不因疲惫而变懒，祝福不因休息而变缓，关怀随星星眨眼，牵挂在深夜依然。',
  '世界上最厉害的人，是说起床就起床，说睡觉就睡觉，说做事就做事，说玩就玩，说收心就收心。从明天开始，不辜负自己，不辜负每一份善意和喜欢。',
  '抛开日常生活的琐碎，忘记白天工作的劳累，让习习晚风当床，让丝丝清凉当被，让我美好祝福陪你入睡。',
  '当我们努力使自己变得比此时更好的时候，我们周围的一切，也会变得更好。',
  '努力做一个可爱的人。不埋怨谁，不嘲笑谁，也不羡慕谁，阳光下灿烂，风雨中奔跑，做自己的梦，走自己的路。',
];

String getRandomly() {
  final rand = Random().nextInt(text.length);
  return text[rand];
}
