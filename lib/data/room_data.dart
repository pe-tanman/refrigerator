class RoomDetailData {
  final String title;
  final String imgPath;

  const RoomDetailData({required this.title, required this.imgPath});
}

class RoomData {
  static const RoomDetailData firstRoom = RoomDetailData(
      title: "タマゴの部屋", imgPath: "images/background/1stStage_background.png");
  static const RoomDetailData secondRoom = RoomDetailData(
      title: "干物の部屋",
      imgPath: "assets/images/background/2ndStage_background.png");
  static const RoomDetailData thirdRoom = RoomDetailData(
      title: "調理室",
      imgPath: "assets/images/background/3rdStage_background.png");
  static const RoomDetailData forthARoom = RoomDetailData(
      title: "細道", imgPath: "assets/images/background/4thStage_background.png");
  static const RoomDetailData forthBRoom = RoomDetailData(
      title: "機械室",
      imgPath: "assets/images/background/4thStage_background.png");
  static const RoomDetailData endingRoom = RoomDetailData(
      title: "主人の書斎",
      imgPath: "assets/images/background4thStage_background.png");

  static RoomDetailData? roomData(int room) {
    switch (room) {
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
