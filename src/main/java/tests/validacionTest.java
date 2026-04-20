
package tests;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class validacionTest {
    @Test
    public void testValidDNI() {

        String dni = "12345678";

        boolean valid = dni.matches("\\d{8}");

        assertTrue(valid);
    }

    @Test
    public void testInvalidDNI() {

        String dni = "123";

        boolean valid = dni.matches("\\d{8}");

        assertFalse(valid);
    }
}
