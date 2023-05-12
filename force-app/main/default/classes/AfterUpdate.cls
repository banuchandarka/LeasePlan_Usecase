/**
 * @author: Banuchandar
 * @date: 11/05/2023
 */

public interface AfterUpdate {
    void handleAfterUpdate(List<sObject> oldList, List<sObject> newList);
}