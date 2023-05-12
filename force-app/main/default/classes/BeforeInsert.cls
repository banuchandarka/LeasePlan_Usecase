/**
 * @author: Banuchandar
 * @date: 11/05/2023
 */

public interface BeforeInsert {
    void handleBeforeInsert(List<sObject> newList);
}