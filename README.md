# zhnBoomView
记得去年的时候看到过安卓类似的效果，当时忙的一b啊。最近挺空的在看各种源码，看到一个用calayer去实现粒子效果的。一下子就想到了那个boom炸裂的效果。果断尝试来实现一波。思路是把`uiiimageview`均分成一个个小方块，然后取这个方块center的位置的图片的颜色赋值给添加上去的layer。然后拿到这个layer做缩放 透明度 position的动画。动画无非就是调参数。。。。。最后把这个效果写到category里面，这样真要用起来还是比较方便的。这gif看起来第一次点的时候效果感觉不好啊，但是实际模拟器上面运行不是这样的。懒得在做一张gif了。



![gif](https://raw.githubusercontent.com/zhnnnnn/zhnBoomView/master/boom.gif)
