# Install-manual-of-RealSense
How to install RealSense on Ubuntu 18.0.4.  
And use it from Python-OpenCV

内容  
pythonからRealSenseを動かす為の環境構築  
RealSense が OpneCV-3.4を要求するのでそれのinstallも込  
ソースコードからビルドした.

対象者  
Ubuntu 環境で Python から OpenCV 使って RealSense を動かしたい人向け  

環境  
公式サイトによると以下をサポート(2019/5/1参照).  
ちなみに自分が使用しているカーネルは`uname -r`で調べる.  
> Ubuntu 16/18 LTS.  
> Ubuntu LTS kernels 4.4, 4.10, 4.13 and 4.15.  

流れ  
1. Install OpenCV-3.4
2. Install OpenCV-contrib-3.4
3. Install something of RealSense


```
$ sudo apt update && sudo apt upgrade && sudo apt dist-upgrade
$ sudo apt install git cmake # If not installed
```

まずはOpenCV に必要なライブラリをインストール.  
4行目はオプションで.  
エラーが出て飛ばしたような気もする.  
```
$ mkdir ~/opencv && cd ~/opencv
$ sudo apt-get install build-essential
$ sudo apt-get install cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev
$ sudo apt-get install python-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev
```

次にOpenCVのソースコードをダウンロード. 
拡張モジュールのcontribも落としてきます.  
今回は最新版ではなく3.4を落とす必要があるのでgitのreleasesで選択します.  
物草な人は以下のコマンドを打てばok.  
ちなみにzipファイルの名前が同じで若干混乱した.
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

そして落としてきたopencvディレクトリでビルドします.  
cmake 関連は[こちらのブログ](http://weekendproject9.hatenablog.com/entry/2018/08/02/185136)を参考(2019/5/1).  
PYTHON_EXECUTABLEの項目は普段自分が使っているバージョンに直しましょう.  
```
$ cd opencv-3.4.6
$ mkdir build && cd build
$ cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D OPENCV_EXTRA_MODULES_PATH=~/opencv/opencv_contrib-3.4.6/modules  -D BUILD_NEW_PYTHON_SUPPORT=ON -D PYTHON_EXECUTABLE=/usr/bin/python3.6 -D BUILD_opencv_python3=ON -D INSTALL_PYTHON_EXAMPLES=ON -D BUILD_EXAMPLES=ON -D ENABLE_FAST_MATH=1 -D WITH_CUBLAS=1 -D WITH_OPENGL=ON  ..
```
最後にmakeします.  
時間かかります.  
```
$ make -j $(nproc)
$ sudo make install
$ sudo /bin/bash -c ‘echo “/usr/local/lib” > /etc/ld.so.conf.d/opencv.conf’
$ sudo  ldconfig
```

一旦ここまで！

公式  
https://github.com/IntelRealSense/librealsense  
ubuntu で導入するひとはここ  
https://github.com/IntelRealSense/librealsense/blob/master/doc/installation.md  
opencv  
https://docs.opencv.org/trunk/d7/d9f/tutorial_linux_install.html
