#include "unity.h"

void setUp(void) {}
void tearDown(void) {}

static void test_unity_funciona(void)
{
    TEST_ASSERT_EQUAL_INT(2, 1 + 1);
    TEST_ASSERT_DOUBLE_WITHIN(1e-9, 0.3, 0.1 + 0.2);
}

int main(void)
{
    UNITY_BEGIN();
    RUN_TEST(test_unity_funciona);
    return UNITY_END();
}
