#include	<stdio.h>
#include	<stdlib.h>
#include	<sys/types.h>
#include	<sys/stat.h>
#include	<fcntl.h>
#include	<unistd.h>

int
main(int argc, char **argv)
{
	if(argc<2) {
		fprintf(stderr,"usage: %s fuzix-binary bm-binary.bin\n",argv[0]);
		exit(1);
	}
	char	*filename = argv[1];
	int		fd = open(filename,O_RDONLY);
	if(fd<0){
		perror(NULL);
		fprintf(stderr,"can't open %s\n",filename);
		exit(1);
	}
	struct	stat	stbuf;
	if(fstat(fd,&stbuf)<0) {
		perror("can't stat");
		exit(1);
	}
	long filesize = stbuf.st_size;
	unsigned char	*buffer;
	if((buffer=(unsigned char *)malloc(filesize+1))==NULL){
		perror("can't malloc");
		exit(1);
	}
	read(fd,buffer,filesize);
	buffer[filesize]=0;
	close(fd);

	char	*filename2 = argv[2];
	int		fd2 = open(filename2,O_RDWR|O_CREAT|O_TRUNC,S_IRUSR|S_IWUSR|S_IRGRP|S_IWGRP);
	if(fd2<0){
		perror(NULL);
		fprintf(stderr,"can't open %s\n",filename2);
		exit(1);
	}
	write(fd2,buffer+0x4000,filesize-0x4000);
	close(fd2);
	
	exit(0);
}
