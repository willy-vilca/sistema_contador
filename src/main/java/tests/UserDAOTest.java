package tests;

import com.accounting.sistemacontador.dao.UserDAO;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class UserDAOTest {

    @Test
    public void testEmailExists() {

        UserDAO dao = new UserDAO();

        boolean result = dao.emailExists("admin@gmail.com");

        assertTrue(result);
    }

    @Test
    public void testEmailNotExists() {

        UserDAO dao = new UserDAO();

        boolean result = dao.emailExists("noexiste@gmail.com");

        assertFalse(result);
    }
}
