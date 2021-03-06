# Install-manual-of-RealSense
How to install RealSense on Ubuntu 16/18 LTS

内容  
* RealSenseをpythonで叩く為の環境をビルド  
* ただし，基本的にはaptとpipで入るのでやらないほうがいいです．  
* aptとpipで環境構築するbashを書きました．以下を読む前に`setup_realsense.sh`を実行してください．  

6/22追記
* pythonラッパーは`pip install pyrealsense2`で入ります．  
  * `pip install pyrealsense`とすると無印のSDKが入ってしまうので注意．  
  * `pip install pyrealsense==2.0`と打っても無印が入るのでダメです．  
  
  
対象者  
* メイン  
  * Ubuntu 環境で python 使って RealSense を動かしたい人
  * 公式のinstall手順(=英語)を読む気になれない人  

* サブ  
  * Ubuntu 環境で C の OpenCV を使って RealSense を動かしたい人
    * RealSense は OpenCV3.4をサポートしています．
  導入手順は[こちら](https://github.com/bulauza/Install-manual-of-OpenCV3.4/blob/master/README.md)を参考に．

流れ  
1. Download RealSense SDK  
2. Build RealSense SDK (with OpenCV)  

## Preparation with ubuntu
```
$ sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade -y
$ sudo apt install -y git cmake
```

## Install RealSense SDK
RealSenseの開発環境を整えていきます.  
RealSenseをパソコンから外して進めていきましょう．  
詳細は[公式のページ](https://github.com/IntelRealSense/librealsense/blob/master/doc/installation.md)を参考.  
特にubuntu14系を使っている人は追加で入力するコマンドがたくさんあります.  
ここではubuntu16/18系での構築を想定して書いていきます．  

### 1. Download RealSense SDK  
First, download SDK from git.  
```
$ cd
$ git clone https://github.com/IntelRealSense/librealsense.git
```
Next, install something library.  
`sudo apt install git libssl-dev libusb-1.0-0-dev pkg-config libgtk-3-dev`  
* Ubuntu16:  
  `sudo apt install libglfw3-dev`
* Ubuntu18:  
  `sudo apt install libglfw3-dev libgl1-mesa-dev libglu1-mesa-dev`  

落としたディレクトリに入って作業していきます．  
```
$ cd librealsense/
$ ./scripts/setup_udev_rules.sh
```
その後  
Ubuntu14/16/18のLTSを使っている人は`$ ./scripts/patch-realsense-ubuntu-lts.sh`  
他使ってる人は公式見てください.  
色んなものを遮断している学校や会社のネットだと通らないことがあるので，  
タイムアウトする場合は場所を変えてやってみてください．  


### 2. Build RealSense SDK with OpenCV  
いよいよBuildです．
librealsense/ 内一番上の階層にいることを確認したら以下を入力．  
C の　OpenCV で開発したい人は上を, Python で開発したい人は下を打ってください．
```
$ mkdir build
$ cd build
# If you want to use SDK with OpenCV 
  $ cmake ../ -DCMAKE_BUILD_TYPE=Release -DBUILD_EXAMPLES=true -DBUILD_CV_EXAMPLES=true
# Other person
  $ cmake ../ -DCMAKE_BUILD_TYPE=Release -DBUILD_EXAMPLES=true -DBUILD_PYTHON_BINDINGS=true
```

終わったら
```
$ sudo make uninstall && make clean && make -j$(nproc) && sudo make install
```
時間かかります．    
メモリが少ないとエラーが出て途中で止まってしまいます．  
`internal compiler error (program cc1plus)`といった出力がされていれば，  
メモリの割り当てを増やしてみてください．  

特に何もなく終われば導入できているはず．  
`$ rs-capture` と打つとデモが開きます．  

最後に python で 使うためにパスを通します．  
ホームディレクトリ直下にある .bashrc を編集して，  
一番下に `export PYTHONPATH=$PYTHONPATH:/usr/local/lib` を追記してください．  
できたら `import pyrealsense2` で確認しましょう．  



## 参考  
[Realsense install guide](https://github.com/IntelRealSense/librealsense)  
ubuntu で導入するひとは[ここ](https://github.com/IntelRealSense/librealsense/blob/master/doc/installation.md)  
cmake のオプション[一覧](https://github.com/IntelRealSense/librealsense/wiki/Build-Configuration)
