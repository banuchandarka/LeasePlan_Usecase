/**
 * @author: Banuchandar
 * @date: 11/05/2023
 */

public interface BeforeDelete {
    void handleBeforeDelete(List<sObject> oldList);
}