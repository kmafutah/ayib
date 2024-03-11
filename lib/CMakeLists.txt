set(AyibLib_SourceFiles
        include/Document.h
        include/Cell.h
        # include/Layer.h
        # include/Network.h
        src/Cell.cpp
        # src/Layer.cpp
        # src/Network.cpp 
        src/Document.cpp)

add_library(AyibLib ${AyibLib_SourceFiles})

target_include_directories(AyibLib
    PUBLIC
        $<INSTALL_INTERFACE:include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src
)

target_link_libraries(AyibLib PRIVATE fmt::fmt fmt::fmt-header-only)

# add_subdirectory(test)