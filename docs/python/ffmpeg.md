## 一、NVIDIA CUDA

参考：[FFmpeg引入NVIDIA硬件编解码扩展—FFmpeg编译教程](https://ffmpeg.xianwaizhiyin.net/compile-ffmpeg/nvidia.html)

本机电脑CUDA版本：`NVIDIA CUDA 9.1.84 driver`

输入命令查看：
``` bash
"C:\Program Files\NVIDIA Corporation\NVSMI\nvidia-smi"
```

[您的 GPU 计算能力](https://developer.nvidia.com/cuda-gpus)
[CUDA下载地址](https://developer.nvidia.com/cuda-toolkit-archive)

[CUDA工具包及对应的驱动版本：](https://docs.nvidia.com/cuda/cuda-toolkit-release-notes/index.html)
| CUDA Toolkit | Toolkit Driver Version |
| CUDA 9.1 (9.1.85) | >= 391.29 |
| CUDA 9.0 (9.0.76) | >= 385.54 |

### 1、安装 CUDA 驱动

安装完`cuda`驱动，配置环境：
在系统变量中加入下面的路径，点击确定： 
> CUDA_BIN_PATH: %CUDA_PATH%\bin
> CUDA_LIB_PATH: %CUDA_PATH%\lib\x64
> CUDA_SDK_PATH: C:\ProgramData\NVIDIA Corporation\CUDA Samples\v11.0
> CUDA_SDK_BIN_PATH: %CUDA_SDK_PATH%\bin\win64
> CUDA_SDK_LIB_PATH: %CUDA_SDK_PATH%\common\lib\x64

在系统变量path中加入下面的的变量：
> %CUDA_BIN_PATH%
> %CUDA_LIB_PATH%
> %CUDA_SDK_BIN_PATH%
> %CUDA_SDK_LIB_PATH%

### 2、检查是否安装成功：

> 1. 打开目录：`C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v9.0\extras\demo_suite`
> 2. 分别运行这两个程序`deviceQuery.exe`、`bandwidthTest.exe`，输出中有`result=pass`则安装成功，否则就重新安装。

查询`cuda`安装是否成功：
``` bash
nvcc -V
```

查询`cuda`安装是环境变量：
``` bash
set cuda
```

## 二、ffmpeg 与 NVIDIA 

查看 FFmpeg 的编译信息：
``` bash
ffmpeg -buildconf
```
在输出信息中，查找与 --enable-cuda 或 --enable-nvenc 相关的行。这些行通常会包含 CUDA 的版本信息。

显示所有可用的硬件加速器，查看是否支持 `CUDA` 和 `NVENC`
``` bash
ffmpeg -hwaccels
# 输出：
 Hardware acceleration methods:
 cuda
 vaapi
 dxva2
 qsv
 d3d11va
 opencl
 vulkan
 d3d12va
```

显示所有编解码器：
``` bash
ffmpeg -codecs
ffmpeg -codecs | find /I "cuvid"
ffmpeg -codecs | find /I "nvenc"

ffmpeg -codecs | find /I "nv"
# 输出：
Codecs:
 D..... = Decoding supported
 .E.... = Encoding supported
 ..V... = Video codec
 ..A... = Audio codec
 ..S... = Subtitle codec
 ..D... = Data codec
 ..T... = Attachment codec
 ...I.. = Intra frame-only codec
 ....L. = Lossy compression
 .....S = Lossless compression
 -------
 DEV.L. av1                  Alliance for Open Media AV1 (decoders: libdav1d libaom-av1 av1 av1_cuvid av1_qsv) (encoders:  libaom-av1 librav1e libsvtav1 av1_nvenc av1_qsv av1_amf av1_mf av1_vaapi)
 D.V.L. dsicinvideo          Delphine Software International CIN video
 DEV.LS h264                 H.264 / AVC / MPEG-4 AVC / MPEG-4 part 10 (decoders: h264 h264_qsv h264_cuvid) (encoders: libx264  libx264rgb h264_amf h264_mf h264_nvenc h264_qsv h264_vaapi h264_vulkan)
 DEV.L. hevc                 H.265 / HEVC (High Efficiency Video Coding) (decoders: hevc hevc_qsv hevc_cuvid) (encoders: libx265  hevc_amf hevc_d3d12va hevc_mf hevc_nvenc hevc_qsv hevc_vaapi hevc_vulkan)
 D.V.L. idcin                id Quake II CIN video (decoders: idcinvideo)
 D.VIL. wnv1                 Winnov WNV1
 D.AIL. twinvq               VQF TwinVQ
```

显示可用的解码器：
``` bash
ffmpeg -decoders | find /I "nv"
# 输出：
 V..... av1_cuvid            Nvidia CUVID AV1 decoder (codec av1)
 V....D dsicinvideo          Delphine Software International CIN video
 V..... h264_cuvid           Nvidia CUVID H264 decoder (codec h264)
 V..... hevc_cuvid           Nvidia CUVID HEVC decoder (codec hevc)
 V....D idcinvideo           id Quake II CIN video (codec idcin)
 V..... mjpeg_cuvid          Nvidia CUVID MJPEG decoder (codec mjpeg)
 V..... mpeg1_cuvid          Nvidia CUVID MPEG1VIDEO decoder (codec mpeg1video)
 V..... mpeg2_cuvid          Nvidia CUVID MPEG2VIDEO decoder (codec mpeg2video)
 V..... mpeg4_cuvid          Nvidia CUVID MPEG4 decoder (codec mpeg4)
 V..... vc1_cuvid            Nvidia CUVID VC1 decoder (codec vc1)
 V..... vp8_cuvid            Nvidia CUVID VP8 decoder (codec vp8)
 V..... vp9_cuvid            Nvidia CUVID VP9 decoder (codec vp9)
 V....D wnv1                 Winnov WNV1
 A....D twinvq               VQF TwinVQ
```

显示可用的编码器：
``` bash
ffmpeg -encoders | find /I "nv"
# 输出：
 V....D av1_nvenc            NVIDIA NVENC av1 encoder (codec av1)
 V....D h264_nvenc           NVIDIA NVENC H.264 encoder (codec h264)
 V....D hevc_nvenc           NVIDIA NVENC hevc encoder (codec hevc)
```

了解一下ffmpeg对Nvidia的GPU编码支持哪些参数，可以通过
``` bash
ffmpeg -h encoder=h264_nvenc

> Supported hardware devices: cuda cuda d3d11va d3d11va
> Supported pixel formats: yuv420p nv12 p010le yuv444p p016le yuv444p16le bgr0 bgra rgb0 rgba x2rgb10le x2bgr10le gbrp gbrp16le cuda d3d11
```

解码时`ffmpeg`对它的参数支持查看：
```
ffmpeg -h decoder=h264_cuvid

> Supported hardware devices: cuda
```

编码示例
使用 Nvidia NVENC 编码 H.264 视频：
``` bash
ffmpeg -i ./x/02.mp4 -c:v h264_nvenc -preset fast -b:v 5M ./output/02.mp4
```

解码示例
使用 Nvidia CUVID 解码 H.264 视频：
``` bash
ffmpeg -hwaccel cuda -i ./x/02.mp4 -c:v h264_cuvid -f null -
```

举一个硬件编解码的例子：
``` bash
ffmpeg -hwaccel cuvid -vcodec h264_cuvid -i ./x/02.mp4 -vcodec h264_nvenc -acodec copy -f mp4 -y ./output/02.mp4

ffmpeg -hwaccel cuda -vcodec h264_cuvid -i ./x/02.mp4 -vcodec h264_nvenc -acodec copy -f mp4 -y ./output/02.mp4
ffmpeg -hwaccel cuda -hwaccel_device 0 -i ./x/02.mp4 -c:v h264_nvenc -preset slow -b:v 5M -y ./output/02.mp4

ffmpeg -hwaccel cuda -i ./x/02.mp4 -c:v h264_nvenc -preset fast ./output/02.mp4 -y
```

问题：
``` bash
Cannot load cuvidGetDecodeStatus
Failed loading nvcuvid.
```
原因：nv-codec-headers 版本与所安装驱动不符
解决办法：使用与显卡驱动相匹配的nv-codec-headers 即可




## 三、提高`ffmpeg`处理视频的速度

在使用`Python`调用`FFmpeg`进行视频转码时，以下几种方法可以帮助你加快转码速度：
### 1. 使用合适的编码器和预设
FFmpeg 提供了不同的编码器和预设选项。选择更快的预设可以大大提高转码速度，虽然可能会影响输出文件的质量和大小。对于 H.264 编码器，以下是一些选项：
> -preset ultrafast: 速度最快，但输出文件较大，质量较低。
> -preset superfast: 速度快，质量适中。
> -preset fast: 速度适中，质量和文件大小平衡。
> -preset medium: 默认设置，速度和质量适中。

### 2. 使用多线程
`FFmpeg`支持多线程处理，可以通过设置`-threads`参数来利用多核`CPU`加速转码。一般情况下，`FFmpeg`会自动选择合适的线程数，但你也可以手动指定：
``` bash
-threads N  # N 是你想使用的线程数
```

### 3. 调整`CRF`（恒定速率因子）
使用`CRF`参数可以在保持质量的同时减少文件大小。一般情况下，`CRF`值在`18 到 28`之间，值越小质量越高，但处理时间会增加。

### 4. 避免不必要的转码
如果视频文件的音频或视频编码已经是目标格式，可以使用`-c copy`参数避免重新编码，从而加快处理速度：
``` bash
-c:v copy -c:a copy
```

### 5. 使用硬件加速
如果你的机器支持`GPU`加速，可以使用硬件加速编码。`FFmpeg`支持多种硬件加速技术，如`NVIDIA NVENC`、`Intel Quick Sync`、`AMD AMF`等。以下是使用`NVIDIA NVENC`的示例：
``` bash
-c:v h264_nvenc
```

### 6. 适当调整分辨率和比特率
如果不需要高分辨率的视频，可以考虑降低分辨率。例如，使用`-vf scale`参数调整分辨率：
``` bash
-vf scale=1280:720  # 将视频缩放到720p
```
同时，可以通过`-b:v`参数调整视频比特率，以减少转码时间：
``` bash
-b:v 1500k  # 设置视频比特率为1500kbps
```
