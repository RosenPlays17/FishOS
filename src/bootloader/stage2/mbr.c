#include "h/disk.h"
#include "h/mbr.h"
#include "h/memory.h"
#include <stdint.h>

typedef struct {
  uint8_t attributes;
  uint8_t chsStart[3];
  uint8_t partitionType;
  uint8_t chsEnd[3];
  uint32_t lbaStart;
  uint32_t size;
} __attribute__((packed)) MBR_Entry;

void MBR_DetectPartition(Partition* part, DISK* disk, void* partition) {
  part->disk = disk;
  if (disk->id < 0x80) {
    part->partitionOffset = 0;
    part->partitionSize = (uint32_t)disk->cylinders * (uint32_t)disk->heads * (uint32_t)disk->sectors;
  }
  else {
    MBR_Entry* entry = (MBR_Entry*)segoffset_to_linear(partition);
    part->partitionOffset = entry->lbaStart;
    part->partitionSize = entry->size;
  }
}

bool Partition_ReadSectors(Partition* part, uint32_t lba, uint8_t sectors, void* lowerDataOut) {
  return DISK_ReadSectors(part->disk, lba + part->partitionOffset, sectors, lowerDataOut);
}
