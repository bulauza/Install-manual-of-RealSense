# Install-manual-of-RealSense
How to install RealSense on Ubuntu 18.0.4  
And use it from Python-OpenCV

内容  
* RealSenseを動かす為の環境構築  
* C言語のOpenCVから使えるようにソースコードからビルド  
* `pip install pyrealsense2`で入るのは無印のSDKで，SDK2には対応していないので注意

対象者  
~~Ubuntu 環境で Python から OpenCV 使って RealSense を動かしたい人~~  
* Ubuntu 環境で C の OpenCV を使って RealSense を動かしたい人
* Ubuntu 環境で python 使って RealSense を動かしたい人

環境  
公式サイトによると以下をサポート(2019/5/1参照).  
ちなみに自分が使用しているカーネルは`uname -r`で調べる.  
> Ubuntu 16/18 LTS.  
> Ubuntu LTS kernels 4.4, 4.10, 4.13 and 4.15.  
公式はVirtualBOX非推奨ですが，筆者はなんとかなっています．

流れ  
1. Download source of OpenCV-3.4  
2. Build OpenCV  
3. Download RealSense SDK  
4. Build RealSense SDK with OpenCV  

If you want to use RealSense SDK from python, start to 3.

## Preparation
```
$ sudo apt update && sudo apt upgrade && sudo apt dist-upgrade
$ sudo apt install git cmake # If not installed
```

## Install OpneCV
### 1. Download source of OpenCV-3.4 
まずはOpenCV に必要なライブラリをインストール.  
4行目はオプションで.  
エラーが出て飛ばしたような気もする.  
```
$ mkdir ~/opencv && cd ~/opencv
$ sudo apt install build-essential
$ sudo apt install cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev
$ sudo apt-get install python-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libdc1394-22-dev
(# libjasper-devはパッケージが見つからないので除外)
```

次にOpenCVのソースコードをダウンロード. 
拡張モジュールのcontribも落としてきます.  
今回は最新版ではなく3.4を落とす必要があるのでgitのreleasesで選択します.  
物草な人は以下のコマンドを打てばok.  
ちなみにzipファイルの名前が同じで若干混乱するので解凍したら削除しておきます.
```
$ wget https://github.com/opencv/opencv/archive/3.4.6.zip
$ unzip 3.4.6.zip
$ rm 3.4.6.zip
$ wget https://github.com/opencv/opencv_contrib/archive/3.4.6.zip
$ unzip 3.4.6.zip
$ rm 3.4.6.zip
```
Finally, check that at least the following files are contained in ~/opencv/ dicrectory.
```
opencv-3.4.6
opencv_contrib-3.4.6
```

### 2. Build OpenCV  
落としてきたopencvディレクトリでビルドします.  
cmake 関連は[こちらのブログ](http://weekendproject9.hatenablog.com/entry/2018/08/02/185136)を参考(2019/5/1).  
PYTHON_EXECUTABLEの項目は普段自分が使っているバージョンに直しましょう.  
```
$ cd opencv-3.4.6
$ mkdir build && cd build
$ cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local\
  -D OPENCV_EXTRA_MODULES_PATH=~/opencv/opencv_contrib-3.4.6/modules\
  -D BUILD_NEW_PYTHON_SUPPORT=ON -D PYTHON_EXECUTABLE=/usr/bin/python3.6\
   -D BUILD_opencv_python3=ON -D INSTALL_PYTHON_EXAMPLES=ON\
   -D BUILD_EXAMPLES=ON -D ENABLE_FAST_MATH=1 -D WITH_CUBLAS=1 -D WITH_OPENGL=ON  ..
```
こんな感じの出力があればよさげ
```
--   Python 3:
--     Interpreter:                 /usr/bin/python3 (ver 3.6.7)
--     Libraries:                   /usr/lib/x86_64-linux-gnu/libpython3.6m.so (ver 3.6.7)
--     numpy:                       /home/bulauza/.local/lib/python3.6/site-packages/numpy/core/include (ver 1.16.2)
--     install path:                lib/python3.6/dist-packages/cv2/python-3.6

```
最後にmakeします.  
時間かかります.  
```
$ make -j $(nproc)
$ sudo make install
$ sudo /bin/bash -c ‘echo “/usr/local/lib” > /etc/ld.so.conf.d/opencv.conf’
$ sudo  ldconfig
```
これでOpenCVは導入できたはず.  
import cv2が通るかどうかを確認してみてください.  
もし `ImportError: libopencv_xfeatures2d.so.3.4: undefined symbol:` というエラーが出たら再起動してみてください．  

最後にパスを通します.  
~/opencv/build ディレクトリ内に`OpenCVConfig.cmake`があることを確認したら以下を入力.  
`$ export OpenCV_DIR=~/opencv/opencv-3.4.6/build`  

## Instakk RealSense SDK
ここまで問題なくできたらいよいよRealSenseの開発環境を整えていきます.  
詳細は[公式のページ](https://github.com/IntelRealSense/librealsense/blob/master/doc/installation.md)を参考にしてください.  
特にubuntu14系を使っている人は追加で入力するコマンドがたくさんあります.  
ここではubuntu16/18系での構築を想定して書いていきます．  

### 3. Download RealSense SDK  
以降RealSenseをパソコンから外して進めていきましょう．  
まずgitからSDKを落とします.  
```
$ cd
$ git clone https://github.com/IntelRealSense/librealsense.git
```
次にもろもろのinstall.  
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
Ubuntu14/16/18のLTSを使っている人は`$ ./scripts/patch-realsense-ubuntu-lts.sh`  
他使ってる人は公式見てください.  


### 4. Build RealSense SDK with OpenCV  
いよいよBuildです．
librealsense/ 内一番上の階層にいることを確認したら以下を入力．  
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
$ export PYTHONPATH=$PYTHONPATH:/usr/local/lib
```
これまた時間かかります．  
特に何もなく終われば導入できているはず．  
import pyrealsense2 で確認しましょう.


#### 参考
[opencv install guide](https://docs.opencv.org/trunk/d7/d9f/tutorial_linux_install.html)  
[Realsense install guide](https://github.com/IntelRealSense/librealsense)  
ubuntu で導入するひとは[ここ](https://github.com/IntelRealSense/librealsense/blob/master/doc/installation.md)  
cmake のオプション[一覧](https://github.com/IntelRealSense/librealsense/wiki/Build-Configuration)
