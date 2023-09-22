class RoomDetailData {
  final String title;
  final String imgPath;
  final List<String> hints;

  const RoomDetailData(
      {required this.title, required this.imgPath, required this.hints});
}

class RoomData {
  static const RoomDetailData tutorialRoom = RoomDetailData(
      title: "始まりの部屋",
      imgPath: "assets/images/background/tutorial_background.png",
      hints: [""]);
  static const RoomDetailData firstRoom = RoomDetailData(
      title: "1の部屋",
      imgPath: "assets/images/background/1stStage_background.png",
      hints: ["茶色の卵は正直です。", "", "答え:黄色の卵"]);
  static const RoomDetailData secondRoom = RoomDetailData(
      title: "2の部屋",
      imgPath: "assets/images/background/2ndStage_background.png",
      hints: [
        "生物図鑑の後ろになにかがある...?",
        "何文字化かアルファベットがズレているのかも",
        "答え:まさんば、とまとまと、きんのみ"
      ]);
  static const RoomDetailData thirdRoom = RoomDetailData(
      title: "3の部屋",
      imgPath: "assets/images/background/3rdStage_background.png",
      hints: [
        "光の三原色と色の三原色の表が貼ってある...",
        "光の部屋ではＣとＹを混ぜるとＷにたどり着く。",
        "色の部屋ではＧとＲを混ぜるとＫにたどり着く。 "
      ]);
  static const RoomDetailData forthARoom = RoomDetailData(
      title: "4の部屋",
      imgPath: "assets/images/background/4thStage_background.png",
      hints: []);
  static const RoomDetailData forthBRoom = RoomDetailData(
      title: "4の部屋",
      imgPath: "assets/images/background/4thStage_background.png",
      hints: []);
  static const RoomDetailData endingRoom = RoomDetailData(
      title: "5の部屋",
      imgPath: "assets/images/background4thStage_background.png",
      hints: ["B=2"]);

  static RoomDetailData? roomData(int room) {
    switch (room) {
      case 0:
        return tutorialRoom;
      case 1:
        return firstRoom;
      case 2:
        return secondRoom;
      case 3:
        return thirdRoom;
      case 4:
        return forthARoom;
      case 5:
        return forthBRoom;
      case 6:
        return endingRoom;

      default:
        return null;
    }
  }
}
