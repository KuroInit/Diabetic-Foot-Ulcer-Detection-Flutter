class Detection {
  String detection;
  String confidence;

  Detection(this.detection, this.confidence);

  @override
  String toString() {
    return '{ ${this.detection}, ${this.confidence} }';
  }

  Detection.fromMap(Map map)
      : this.detection = map['detection'],
        this.confidence = map['confidence'];

  Map toMap() {
    return {
      'detection': this.detection,
      'confidence': this.confidence,
    };
  }
}
