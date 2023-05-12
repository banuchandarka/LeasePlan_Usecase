/**
 * @author: Banuchandar
 * @date: 11/05/2023
 */

public interface AfterDelete {
    void handleAfterDelete(List<sObject> oldList);
}