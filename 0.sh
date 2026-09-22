# cd ~/linux-7.0

# # 清理旧产物（第一次编跳过，改过 .config 后建议跑一次）
# make clean

# # 编译
# make bzImage -j8

# cd /busybox-1.38.0
# make menuconfig
# make -j8
# make install 

git clone 