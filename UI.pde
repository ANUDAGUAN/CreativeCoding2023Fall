void UI() {
  cp = new ControlP5(this, createFont("微软雅黑", 16));
  cp.addSlider("sw", 0, 200, 1, 50, 50 + layer * 30 + 10, 200, 30).setLabel("笔触");
  cp.addSlider("section", 3, 128, 36, 50, 50 + layer * 30 + 40, 200, 30).setLabel("截面细分");
  cp.addSlider("cyHigth", 3, 128, 20, 50, 50 + layer * 30 + 70, 200, 30).setLabel("层间高度");


  // Add sliders for each layer's X radius
  for (int i = 0; i < layer; i++) {
    final int layerIndex = i;
    cp.addSlider("layerRadiiX_" + i, 50, 200, 100, 50, 50 + i * 30, 200, 30)
      .setLabel("Layer " + i + " X Radius")
      .addCallback(new CallbackListener() {
        public void controlEvent(CallbackEvent event) {
          if (event.getAction() == ControlP5.ACTION_RELEASED) {
            layerRadiiX[layerIndex] = cp.getController("layerRadiiX_" + layerIndex).getValue();
          }
        }
      });
  }

  // Add sliders for each layer's Y radius
  for (int i = 0; i < layer; i++) {
    final int layerIndex = i;
    cp.addSlider("layerRadiiY_" + i, 25, 100, 50, 300 + i * 30, 200, 30)
      .setLabel("Layer " + i + " Y Radius")
      .addCallback(new CallbackListener() {
        public void controlEvent(CallbackEvent event) {
          if (event.getAction() == ControlP5.ACTION_RELEASED) {
            layerRadiiY[layerIndex] = cp.getController("layerRadiiY_" + layerIndex).getValue();
          }
        }
      });
  }




  cp.setAutoDraw(false);
}
