add_executable(AyibTest Tests.cpp)

target_link_libraries(AyibTest PRIVATE AyibLib)
target_link_libraries(AyibTest PRIVATE Catch2::Catch2)