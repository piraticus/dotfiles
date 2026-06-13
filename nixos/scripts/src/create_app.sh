#! /bin/sh

read -p "Enter path to new app: " path
read -p "Enter app name: " appName

if [[ $path == *"\\"* ]]; then
    echo "incorrect file path"
    exit -1
fi

if [[ -d $path ]]; then
    echo "a directory with that name already exists"
    exit -1
fi

# readarray -d "/" -t pathArray <<< "$path"

# for word in "${pathArray[@]}"; 
# do 
#  printf "%s\n" "$word" 
# done

mkdir -p $path

touch $path/.gitignore
touch $path/prj.conf
touch $path/README.md


mkdir $path/boards
mkdir $path/nix
mkdir $path/include
mkdir $path/source
mkdir $path/documentation

echo 'cmake_minimum_required(VERSION 3.20.0)
set(ZEPHYR_MODULES $ENV{ZEPHYR_MODULES_BASE}/hal_nxp;$ENV{ZEPHYR_MODULES_BASE}/CMSIS_6;)

find_package(Zephyr REQUIRED HINTS $ENV{ZEPHYR_BASE})

set(PROJECT_NAME app)

project(${PROJECT_NAME})

target_sources(${PROJECT_NAME} PRIVATE
    ${CMAKE_CURRENT_LIST_DIR}/source/main.c
)

target_include_directories(${PROJECT_NAME} PRIVATE
    ${CMAKE_CURRENT_LIST_DIR}/include
)' >> $path/CMakeLists.txt

echo 'default:
legacyPackages:
let
  vars = import ./shared-vars.nix legacyPackages;
  packages = with legacyPackages;[
    python3
    python3Packages.pykwalify
    python3Packages.pyyaml
    python3Packages.packaging
    python3Packages.pyelftools
    python3Packages.jsonschema
    gcc-arm-embedded
    dtc
    ninja
    cmake
  ];
  
in{
  firmware = default.override{
    project_name = vars.name;
    project_version = vars.version;

    inputs = packages;
    cmakeFlags = vars.cmakeFlags;
    path = vars.app-path;
    extraConfigs = vars.submodules;
  };
}' >> $path/nix/firmware.nix

printf 'legacyPackages:
let
  path = "$(pwd)";
  app-path = "${path}/%s";
  board = "";
in{
  inherit path app-path;
  name = "%s";
  version = "0.0.0";
  cmakeFlags = [
    "-DDTC_OVERLAY_FILE=${app-path}/boards/.overlay"
    "-DBOARD_ROOT=${path}/"
    "-DDTS_ROOT=${path}/"
    "-DSOC_ROOT=${path}/"
    "-DBOARD=${board}"
    "-DZEPHYR_TOOLCHAIN_VARIANT=gnuarmemb"
    "-DGNUARMEMB_TOOLCHAIN_PATH=${legacyPackages.gcc-arm-embedded}"
  ];

  nativeCmakeFlags = [
    "-DDTC_OVERLAY_FILE=${app-path}/boards/native_sim.overlay"
    "-DBOARD_ROOT=${path}/"
    "-DDTS_ROOT=${path}/"
    "-DBOARD=native_sim"
  ];
  submodules = $s
               $s;
}' "${path}" "${appName}" "''" "''">> $path/nix/shared-vars.nix

printf 'default:
legacyPackages:
let
  vars = import ./shared-vars.nix legacyPackages;
  
  localPrompt = "${vars.name}";
  hook = %s
         ${vars.submodules}
          export cmakeFlags="${builtins.toString(vars.cmakeFlags)}"
          export appPath="${vars.app-path}"
         %s;
  nativeHook = %s
               ${vars.submodules}
               export cmakeFlags="${builtins.toString(vars.nativeCmakeFlags)}"
               export appPath="${vars.app-path}"
               %s;
  
  packages = with legacyPackages;[
    python3
    python3Packages.pykwalify
    python3Packages.pyyaml
    python3Packages.packaging
    python3Packages.pyelftools
    python3Packages.jsonschema
    gcc-arm-embedded
    dtc
    ninja
  ];
in{

  shell = default.override{prompt = localPrompt; additionalHook = hook; shellPackages = packages;};
  native = default.override{prompt = "${vars.name}-native_sim"; additionalHook = nativeHook; shellPackages = packages ++ [legacyPackages.zephyr-sdk legacyPackages.gcc_multi];};
}
' "''" "''" "''" "''" >> $path/nix/shell.nix

echo 'int main(void) {
	return 0;
}' >> $path/source/main.c
