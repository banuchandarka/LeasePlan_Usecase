/**
 * @author: Banuchandar
 * @date: 11/05/2023
 */

public interface AfterInsert {
    void handleAfterInsert(List<sObject> newList);
}