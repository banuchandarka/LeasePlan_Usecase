/**
 * @author: Banuchandar
 * @date: 11/05/2023
 */

public interface BeforeUndelete {
    void handleBeforeUndelete(List<sObject> newList);
}