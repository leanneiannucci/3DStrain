ffmpeg -i ./3D/3DVIDEONAMEHERE.avi -map 0:0 -map 0:1 -vcodec copy -acodec copy ./Split/3DVIDEONAMEHERE_L.avi

ffmpeg -i ./3D/3DVIDEONAMEHERE.avi -map 0:2 -vcodec copy -acodec copy ./Split/3DVIDEONAMEHERE_R.avi
