#!/bin/bash

getLogicalVolumeLinux() {
    echo "=========================================="
    echo "     🔍 Información de Volúmenes LVM      "
    echo "=========================================="
    
    # Mostrar Physical Volumes
    echo -e "\n📦 Physical Volumes (PV):"
    pvs --units g --separator ' | ' --noheadings -o pv_name,vg_name,pv_size,pv_free | column -t
    
    # Mostrar Volume Groups
    echo -e "\n📂 Volume Groups (VG):"
    vgs --units g --separator ' | ' --noheadings -o vg_name,vg_size,vg_free,vg_attr | column -t
    
    # Mostrar Logical Volumes
    echo -e "\n📁 Logical Volumes (LV):"
    lvs --units g --separator ' | ' --noheadings -o lv_name,vg_name,lv_size,lv_attr,lv_path | column -t
    
    echo -e "\n✅ Finalizado.\n"

}

getLogicalVolumeSolaris(){

    echo "=========================================="
    echo "  🧮 Información de Volúmenes en Solaris  "
    echo "=========================================="
    
    # Verificar si zfs está disponible
    if command -v zpool >/dev/null 2>&1 && command -v zfs >/dev/null 2>&1; then
      echo -e "\n🔹 Detected: ZFS"
    
      echo -e "\n🏊 ZFS Pools:"
      zpool list
    
      echo -e "\n🔍 Estado de Pools:"
      zpool status
    
    else
      echo -e "\n⚠️ ZFS no detectado o no disponible."
    fi
    
    # Verificar si SVM está disponible
    if command -v metastat >/dev/null 2>&1; then
      echo -e "\n🔹 Detected: Solaris Volume Manager (SVM)"
    
      echo -e "\n📊 Metastat:"
      metastat
    
      echo -e "\n🗃️ Metadb:"
      metadb
    
      echo -e "\n📦 Filesystems montados:"
      df -h | grep -E '^/dev/md'
    else
      echo -e "\n⚠️ SVM no detectado o no disponible."
    fi
    
    echo -e "\n✅ Finalizado."
    
}

getLogicalVolumeAIX(){
    
    echo "==============================================="
    echo "      💾 Información de Volúmenes en AIX        "
    echo "==============================================="
    
    # Physical Volumes
    echo "\n📦 Physical Volumes (PVs):"
    lspv | awk '{printf "%-20s %-20s %-20s\n", $1, $2, $3}'
    
    # Volume Groups
    echo "\n📂 Volume Groups (VGs):"
    for vg in $(lsvg); do
      echo "\n🔸 VG: $vg"
      lsvg $vg
    done
    
    # Logical Volumes
    echo "\n📁 Logical Volumes (LVs):"
    for vg in $(lsvg); do
      echo "\n🔸 LVs en $vg:"
      lsvg -l $vg
    done
    
    echo "\n✅ Finalizado."

}

if [ $# -ne 1 ]; then
    echo "Uso: $0 [linux|solaris|aix]"
    exit 1
fi

case "$1" in
    linux)
        getLogicalVolumeLinux
        ;;
    solaris)
        getLogicalVolumeSolaris
        ;;
    aix)
        getLogicalVolumeAIX
        ;;
    *)
        echo "SO no soportado. Use 'linux' | 'solaris' | 'aix' "
        exit 1
        ;;
esac