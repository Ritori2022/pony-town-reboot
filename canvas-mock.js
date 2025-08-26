// Canvas mock for Node.js environment
// This is a temporary workaround to avoid canvas compilation issues

function createCanvas(width, height) {
  return {
    width: width,
    height: height,
    getContext: function(type) {
      return {
        fillStyle: '#000000',
        strokeStyle: '#000000',
        lineWidth: 1,
        fillRect: function() {},
        strokeRect: function() {},
        clearRect: function() {},
        fill: function() {},
        stroke: function() {},
        beginPath: function() {},
        closePath: function() {},
        moveTo: function() {},
        lineTo: function() {},
        quadraticCurveTo: function() {},
        bezierCurveTo: function() {},
        arc: function() {},
        arcTo: function() {},
        rect: function() {},
        scale: function() {},
        rotate: function() {},
        translate: function() {},
        transform: function() {},
        setTransform: function() {},
        resetTransform: function() {},
        save: function() {},
        restore: function() {},
        drawImage: function() {},
        createImageData: function() { return { data: new Uint8ClampedArray(width * height * 4) }; },
        getImageData: function() { return { data: new Uint8ClampedArray(width * height * 4), width: width, height: height }; },
        putImageData: function() {}
      };
    },
    toBuffer: function() {
      return Buffer.alloc(0);
    }
  };
}

function Image() {
  this.width = 0;
  this.height = 0;
  this.src = null;
  this.onload = null;
  this.onerror = null;
}

module.exports = {
  createCanvas: createCanvas,
  Image: Image,
  Canvas: function() { return createCanvas(0, 0); }
};