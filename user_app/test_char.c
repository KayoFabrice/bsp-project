#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>

#define DEVICE "/dev/sensor_hub"

int main() {
    int fd = open(DEVICE, O_RDWR);
    if (fd < 0) {
        perror("open");
        return 1;
    }

    char write_buf[] = "Hello Sensor Hub!";
    write(fd, write_buf, strlen(write_buf));

    char read_buf[1024] = {0};
    lseek(fd, 0, SEEK_SET);  // rewind buffer
    read(fd, read_buf, sizeof(read_buf));
    printf("Read from device: %s\n", read_buf);

    close(fd);
    return 0;
}
